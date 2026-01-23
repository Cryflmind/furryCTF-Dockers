#!/bin/sh

# 定义标记文件路径
FLAG_FILE="/tmp/2HNWwTaqQJqe3f0W"

# 判断标记文件是否存在
if [ ! -f "$FLAG_FILE" ]; then
    echo "Init..........."
    cd /
    wget https://www.****.com/hiredis.zip
    unzip hiredis.zip
    cd hiredis
    mkdir build && cd build
    cmake ..
    make
    make install

    # 编译 redis-plus-plus
    cd /
    wget https://www.****.com/redis-plus-plus.zip
    unzip redis-plus-plus.zip
    cd redis-plus-plus
    mkdir build && cd build

    cmake .. -DCMAKE_INSTALL_PREFIX=/usr
    make
    make install

    touch "$FLAG_FILE"
else
    echo ""
fi

/app/server
