FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/node:16-alpine

# 更换源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update --no-cache

# [新增] 安装 sqlite3 编译所需的依赖 (python3, make, g++)
RUN apk add --no-cache gcc musl-dev python3 make g++

WORKDIR /app

COPY service/package.json .

# 设置淘宝源加速
RUN npm config set registry https://registry.npmmirror.com
RUN npm install

COPY --chown=node:node service/ .

# 编译 readflag
COPY files/readflag.c /tmp/readflag.c
RUN gcc /tmp/readflag.c -o /readflag && chmod 4755 /readflag && rm /tmp/readflag.c

# 创建 Flag 占位
RUN echo "GZCTF{Test_Flag_Here}" > /flag
RUN chmod 0600 /flag

# 启动脚本
COPY start.sh /
RUN chmod +x /start.sh

EXPOSE 3000

ENTRYPOINT ["/start.sh"]