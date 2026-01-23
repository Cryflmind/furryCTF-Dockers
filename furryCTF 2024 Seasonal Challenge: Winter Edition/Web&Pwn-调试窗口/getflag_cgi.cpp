// /www/cgi-bin/getflag1.cgi

#include <cctype>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

const char *flag = "furryCTF{Be_The_K1";

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
      v.push_back(tmp);
      tmp = "";
      continue;
    }
    tmp += tolower(query[i]);
  }
  if (tmp != "") {
    v.push_back(tmp);
  }
  for (const string &s : v) {
    if (s == "is_admin=1") {
      cout << flag << endl;
      return 0;
    }
  }
  cout << "Forbidden." << endl;
  return 0;
}
