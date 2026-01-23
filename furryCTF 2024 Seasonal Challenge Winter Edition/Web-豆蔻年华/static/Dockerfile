FROM vulhub/redis:5.0.7

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive


# Add basics first
RUN apt update 
RUN apt install wget bash apache2  nano -y

COPY ./app /app
COPY ./resource/httpd.conf /etc/apache2/apache2.conf 

# Add Composer
# RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer


RUN mkdir /var/www/logs/

# RUN mkdir /app
RUN chown -R www-data:www-data /app
RUN chmod -R 755 /app 

RUN mkdir bootstrap
ADD start.sh /bootstrap/
RUN chmod +x /bootstrap/start.sh

RUN echo "" >> /etc/apache2/mime.types
RUN chown  www-data:www-data /etc/apache2/mime.types

# flag
RUN echo "furryCTF{Cross_The_Barr1er_Of_Safe_B0x_With_Lua}" >> /flag.txt

EXPOSE 80
ENTRYPOINT ["/bootstrap/start.sh"]
