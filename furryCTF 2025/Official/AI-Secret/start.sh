#!/bin/bash

# 启动后端服务
cd /app/backend
python app.py &

# 修改前端index.html中的API_URL
sed -i "s|const API_URL = 'http://localhost:5000';|const API_URL = '/api';|g" /usr/share/nginx/html/index.html

# 启动nginx
nginx -g "daemon off;"
