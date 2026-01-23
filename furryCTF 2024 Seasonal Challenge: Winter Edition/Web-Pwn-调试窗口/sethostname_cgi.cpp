// /www/cgi-bin/sethostname.cgi

#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

#ifdef WINNT
#define po _popen
#define pc _pclose
#else
#define po popen
#define pc pclose
#endif

const char *flag = "furryCTF{}";
char buf[2048];

unsigned char ToHex(unsigned char x) { return x > 9 ? x + 55 : x + 48; }

unsigned char FromHex(unsigned char x) {
  unsigned char y;
  if (x >= 'A' && x <= 'Z')
    y = x - 'A' + 10;
  else if (x >= 'a' && x <= 'z')
    y = x - 'a' + 10;
  else if (x >= '0' && x <= '9')
    y = x - '0';
  else
    return '0';
  return y;
}

std::string UrlDecode(const std::string &str) {
  std::string strTemp = "";
  size_t length = str.length();
  for (size_t i = 0; i < length; i++) {
    if (str[i] == '+')
      strTemp += ' ';
    else if (str[i] == '%') {
      unsigned char high = FromHex((unsigned char)str[++i]);
      unsigned char low = FromHex((unsigned char)str[++i]);
      strTemp += high * 16 + low;
    } else
      strTemp += str[i];
  }
  return strTemp;
}

int main() {
  cout << "Content-type:text/plain\r\n\r\n";
  char *query = getenv("QUERY_STRING");
  if (!query) {
    cout << "Forbidden." << endl;
    return 0;
  }
  vector<string> v;

  int len = strlen(query);
  string tmp = "";
  for (int i = 0; i < len; ++i) {
    if (query[i] == '&') {
      v.push_back(UrlDecode(tmp));
      tmp = "";
      continue;
    }
    tmp += tolower(query[i]);
  }
  if (tmp != "") {
    v.push_back(UrlDecode(tmp));
  }
  for (const string &s : v) {
    if (s == "is_admin=1") {
      goto success;
    }
  }
  cout << "Forbidden." << endl;
  return 0;
success:
  vector<string> vv;
  for (const string &s : v) {
    vv.clear();
    tmp = "";
    for (const char &c : s) {
      if (c == '=') {
        vv.push_back(tmp);
        tmp = "";
        continue;
      }
      tmp += c;
    }
    if (tmp != "") {
      vv.push_back(tmp);
    }
    if (vv.size() != 2) {
      cout << "Bad Request." << endl;
      return 0;
    }
    if (vv[0] == "hostname") {
      FILE *fp = NULL;
      string cmd = "/tools/sethostname " + vv[1];
      if ((fp = popen(cmd.c_str(), "r")) != NULL) {
        fread(buf, sizeof(char), sizeof(buf), fp);
        pclose(fp);
      }
      cout << buf << endl;
      return 0;
    }
  }
  return 0;
}
