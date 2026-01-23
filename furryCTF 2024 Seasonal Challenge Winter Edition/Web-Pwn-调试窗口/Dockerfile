FROM alpine:latest AS builder

WORKDIR /build

#RUN echo "http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/testing" >> /etc/apk/repositories
#RUN echo "http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.13/community" >> /etc/apk/repositories
RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
RUN sed -i 's/https/http/' /etc/apk/repositories

RUN apk add --no-cache --update build-base && rm -rf /var/cache/apk/*

COPY *.cpp ./

RUN g++ getflag_cgi.cpp -o getflag.cgi
RUN g++ sethostname_cgi.cpp -o sethostname.cgi
RUN g++ sethostname.cpp -o sethostname

FROM alpine:latest AS runner

WORKDIR /

RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
RUN sed -i 's/https/http/' /etc/apk/repositories

RUN apk add --update --no-cache \
    lighttpd \
    libstdc++ libgcc libc6-compat \
    && rm -rf /var/cache/apk/*

RUN mkdir /flag && mkdir -p /www/cgi-bin && mkdir -p /www && mkdir /tools

COPY flag2.txt /flag/

COPY ./htdocs /www

COPY ./lighttpd.conf /

COPY --from=builder /build/sethostname /tools/

COPY --from=builder /build/*.cgi /www/cgi-bin/

CMD [ "lighttpd", "-D", "-f", "/lighttpd.conf" ]
