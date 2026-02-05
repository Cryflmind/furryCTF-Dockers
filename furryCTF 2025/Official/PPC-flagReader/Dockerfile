FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y nginx curl && rm -rf /var/lib/apt/lists/*

COPY backend/ /app/backend/
COPY frontend/ /var/www/html/

RUN pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn && \
    pip install --no-cache-dir -r backend/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn

RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-available/flag-viewer
RUN ln -s /etc/nginx/sites-available/flag-viewer /etc/nginx/sites-enabled/

# 复制启动脚本并设置权限
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 80

# 使用启动脚本
CMD ["/app/start.sh"]
