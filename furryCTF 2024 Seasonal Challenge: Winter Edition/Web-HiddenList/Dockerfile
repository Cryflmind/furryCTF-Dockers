FROM alpine:3.16

COPY ./static /app

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" | tee -a /etc/apk/repositories > /dev/null
RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
RUN sed -i 's/https/http/' /etc/apk/repositories

RUN apk update
RUN apk add gcc cmake make build-base openssl-dev 


ENTRYPOINT ["/app/server"]