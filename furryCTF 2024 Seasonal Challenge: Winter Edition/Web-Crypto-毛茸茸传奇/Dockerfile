FROM alpine:latest

COPY ./static /app

RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
RUN sed -i 's/https/http/' /etc/apk/repositories

RUN apk update
RUN apk add gcc cmake make build-base wget openssl git

RUN chmod +x /app/start.sh

ENTRYPOINT ["/app/start.sh"]


