#!/bin/sh

# 1. 优先检测 GZCTF_FLAG (GZCTF 平台默认变量名)
if [ -n "$GZCTF_FLAG" ]; then
    echo "$GZCTF_FLAG" > /flag
# 2. 其次检测 FLAG (通用 CTF 变量名)
elif [ -n "$FLAG" ]; then
    echo "$FLAG" > /flag
fi

# 3. 锁定 Flag 文件权限 (仅 root 可读，必须通过 readflag 程序读取)
chmod 0400 /flag
chown root:root /flag

# 4. 降权启动 Node.js 应用
# 注意：之前我们在 Dockerfile 里写了 USER node，现在改用 su 切换
# 这样脚本能以 root 身份先写 flag，再变成 node 身份跑服务
echo "[*] Flag initialized. Starting server as user 'node'..."
exec su node -c "node app.js"