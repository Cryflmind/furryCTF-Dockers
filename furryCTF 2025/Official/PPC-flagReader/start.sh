#!/bin/bash

# 启动后端服务
cd /app/backend
gunicorn -w 4 -b 0.0.0.0:5000 --preload --access-logfile - --error-logfile - --timeout 120 app:app &
sleep 2
# 等待后端服务启动
echo "等待后端服务启动..."
# 检查后端是否健康
curl -f http://127.0.0.1:5000/health > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "后端服务启动成功"
else
    echo "后端服务启动失败"
    exit 1
fi

# 启动 nginx
echo "启动 Nginx..."
nginx -g 'daemon off;'
