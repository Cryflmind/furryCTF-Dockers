FROM node:16-alpine

# 设置国内镜像源
RUN echo "https://mirrors.aliyun.com/alpine/v3.16/main/" > /etc/apk/repositories \
    && echo "https://mirrors.aliyun.com/alpine/v3.16/community/" >> /etc/apk/repositories \
    && npm config set registry https://registry.npmmirror.com \
    && npm config set disturl https://npmmirror.com/dist

# 安装系统依赖
RUN apk add --no-cache \
    nginx \
    bash \
    curl \
    jq \
    python3 \
    make \
    g++ \
    git \
    && mkdir -p /run/nginx /usr/share/nginx/html /app /app/secure /var/lib/nginx/logs /var/log/nginx /tmp/logs \
    && npm install -g ganache-cli@6.12.2

WORKDIR /app

# 复制所有文件
COPY . .

# 安装项目依赖
RUN npm install web3@1.7.5 solc@0.8.19 ethers@5.7.2 \
    && chmod +x init.sh \
    && cp index.html /usr/share/nginx/html/ \
    && cp nginx.conf /etc/nginx/nginx.conf \
    && cp target.sol /usr/share/nginx/html/

# 设置权限 - 在切换用户前创建所有需要的目录
RUN chmod 700 /app/secure \
    && mkdir -p /tmp \
    && touch /tmp/ganache.log \
    && mkdir -p /var/lib/nginx /var/log/nginx /var/lib/nginx/logs /tmp/logs \
    && chown -R nobody:nobody /app \
    && chown -R nobody:nobody /usr/share/nginx/html \
    && chown -R nobody:nobody /var/log/nginx \
    && chown -R nobody:nobody /var/lib/nginx \
    && chown -R nobody:nobody /tmp \
    && chown -R nobody:nobody /run/nginx \
    && chmod 755 /var/log /var/lib /tmp /tmp/logs /run/nginx

# 切换到非root用户（增强安全性）
USER nobody

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# 启动命令
CMD ["./init.sh"]