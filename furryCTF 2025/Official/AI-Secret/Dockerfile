# 使用Python 3.11作为基础镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 直接创建完整的清华源配置文件
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 配置pip使用清华镜像源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn

# 复制后端文件
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制后端代码
COPY backend/ /app/backend/

# 复制前端文件到nginx目录
COPY frontend/ /usr/share/nginx/html/

# 复制nginx配置
COPY nginx.conf /etc/nginx/nginx.conf

# 复制启动脚本
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# 暴露端口
EXPOSE 80

# 设置环境变量
ENV DEEPSEEK_API_KEY=[DEEPSEEK-API-KEY]
ENV DEEPSEEK_BASE_URL=https://api.deepseek.com
ENV MODEL=deepseek-chat

# 启动应用
CMD ["/app/start.sh"]
