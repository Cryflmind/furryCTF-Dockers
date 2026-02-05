FROM php:8.0-apache

# 设置时区
ENV TZ=Asia/Shanghai

# 安装必要的软件包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tzdata && \
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    docker-php-ext-install pdo pdo_mysql && \
    rm -rf /var/lib/apt/lists/*

# 启用 Apache 重写模块
RUN a2enmod rewrite

# 复制网站文件
COPY . /var/www/html/

# 设置适当的权限
RUN chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

# 复制并执行 flag.sh
#COPY flag.sh /tmp/flag.sh
#RUN chmod +x /tmp/flag.sh && /tmp/flag.sh && rm -f /tmp/flag.sh

# 复制 flag.sh（不删除，留待运行时使用）
COPY flag.sh /tmp/flag.sh
RUN chmod +x /tmp/flag.sh

# 修改 CMD，在启动时执行 flag.sh
CMD /tmp/flag.sh && apache2-foreground
