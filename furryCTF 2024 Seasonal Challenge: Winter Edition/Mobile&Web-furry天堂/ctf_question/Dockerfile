FROM alpine:edge

COPY ./resource/app /app

COPY ./resource/httpd.conf /etc/apache2/httpd.conf 
COPY ./resource/ctf_question.sql /ctf_question.sql
COPY ./resource/my.cnf /my.cnf

# RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" >> /etc/apk/repositories
# RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community/community" >> /etc/apk/repositories
# RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/community" >> /etc/apk/repositories
# RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.13/community" >> /etc/apk/repositories
RUN sed -i 's/https/http/' /etc/apk/repositories
# Add basics first
RUN apk update 
RUN apk upgrade 
RUN apk add wget bash apache2 php7-apache2 curl ca-certificates openssl openssh git php7 php7-phar php7-json php7-iconv php7-openssl tzdata openntpd nano

# Add Composer
# RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Setup apache and php
RUN apk add \
	php7-ftp \
	php7-xdebug \
	php7-mcrypt \
	php7-mbstring \
	php7-soap \
	php7-gmp \
	php7-pdo_odbc \
	php7-dom \
	php7-pdo \
	php7-zip \
	php7-mysqli \
	php7-sqlite3 \
	php7-pdo_pgsql \
	php7-bcmath \
	php7-gd \
	php7-odbc \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-gettext \
	php7-xml \
	php7-xmlreader \
	php7-xmlwriter \
	php7-tokenizer \
	php7-xmlrpc \
	php7-bz2 \
	php7-pdo_dblib \
	php7-curl \
	php7-ctype \
	php7-session \
	php7-redis \
	php7-exif \
	# php7-intl \
	php7-fileinfo \
	# php7-ldap \
	php7-apcu

# Problems installing in above stack
RUN apk add php7-simplexml

RUN cp /usr/bin/php7 /usr/bin/php \
    && rm -f /var/cache/apk/*

RUN apk add --no-cache mysql mysql-client
RUN apk add openrc --no-cache
# RUN rc-status
# RUN rc-update add mariadb default
# RUN touch /run/openrc/softlevel
# RUN /etc/init.d/mariadb setup


# Add apache to run and configure
RUN sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_module/LoadModule\ session_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_cookie_module/LoadModule\ session_cookie_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_crypto_module/LoadModule\ session_crypto_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ deflate_module/LoadModule\ deflate_module/" /etc/apache2/httpd.conf \
    && sed -i "s#^DocumentRoot \".*#DocumentRoot \"/app/public\"#g" /etc/apache2/httpd.conf \
    && sed -i "s#/var/www/localhost/htdocs#/app/public#" /etc/apache2/httpd.conf \
    && printf "\n<Directory \"/app/public\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf


RUN chown -R apache:apache /app
# RUN chmod -R 755 /app 
RUN mkdir bootstrap
ADD start.sh /bootstrap/
RUN chmod +x /bootstrap/start.sh

RUN echo "furryCTF{Apache_1s_N0t_Static_As_We1l}" >> /flag.txt
RUN chmod 444 /flag.txt
RUN chmod -R 544 /app
RUN chmod -R 744 /app/public/uploads/
RUN chmod -R 744 /app/runtime/log/
RUN echo "1" >> /bootstrap/first_run

# RUN rc-service mariadb start
# RUN mysqladmin -u root password "PMkrcMsxfpL2nRpE"

EXPOSE 80
ENTRYPOINT ["/bootstrap/start.sh"]
