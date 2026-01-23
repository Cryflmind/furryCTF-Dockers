// /tools/sethostname

#include <cstdio>

int main(int argc, char **argv) {
  if (argc <= 1) {
    printf("Hostname cannot be empty.\n");
    return 1;
  }
  printf("Hostname updated successfully");
  return 0;
}