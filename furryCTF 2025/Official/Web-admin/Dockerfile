# 使用官方PHP 8.4 CLI镜像作为基础:cite[1]
FROM php:8.4-cli

# 安装系统依赖和PHP扩展:cite[1]:cite[5]
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    && docker-php-ext-install zip

# 安装Composer:cite[1]
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 设置工作目录:cite[1]
WORKDIR /var/www/html

# 将当前目录下的所有文件复制到容器的工作目录
COPY . .

# 暴露端口
EXPOSE 8080

# 启动内置的PHP开发服务器:cite[5]
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]