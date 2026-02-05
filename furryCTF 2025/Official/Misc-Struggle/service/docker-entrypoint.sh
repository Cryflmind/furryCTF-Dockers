#!/bin/sh

# 删除启动脚本，以防非预期
rm -f /app/docker-entrypoint.sh

# 将环境变量GZCTF_FLAG的数据写入/app/flag
if [ -n "$GZCTF_FLAG" ]; then
    echo "$GZCTF_FLAG" > /app/flag
    echo "Flag已写入 /app/flag"
else
    echo "警告: GZCTF_FLAG 环境变量为空"
fi

cd /app

# 设置UTF-8编码环境变量
export PYTHONIOENCODING=utf-8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# 通过socat转发Python会话
# TCP4-LISTEN:9999 服务将会转发到9999端口
# reuseaddr 启用端口复用，便于多用户同时连接同一个端口
# stderr 将脚本的stderr错误输出流也定向到用户会话
socat -v -s TCP4-LISTEN:9999,tcpwrap=script,reuseaddr,fork EXEC:"python3 -u /app/main.py",stderr