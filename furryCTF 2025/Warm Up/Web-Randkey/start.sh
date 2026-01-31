#!/bin/bash

# 1. 动态 Flag 处理 (适配 GZCTF)
# 如果环境变量 GZCTF_FLAG 存在，就用它；否则用默认值
flag_value="${GZCTF_FLAG:-flag{local_test_flag_123}}"
echo "$flag_value" > /flag
chmod 444 /flag

# 为了安全，清空环境变量中的 flag
unset GZCTF_FLAG

# 2. 启动 Nginx (后台运行)
echo "[+] Starting Nginx..."
service nginx start

# 3. 启动 Flask (Gunicorn 前台运行)
# 绑定到 127.0.0.1:5000，只能通过 Nginx 访问
echo "[+] Starting Flask App..."
exec gunicorn -w 2 -b 127.0.0.1:5000 app:app
