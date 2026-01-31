FROM python:2.7

WORKDIR /app

# 安装 pexpect
RUN pip install pexpect==4.8.0 tornado -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY server.py DeepSleep.html flag DeepSleep.py /app/
COPY entrypoint.sh /app/

# 给entrypoint.sh执行权限
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]