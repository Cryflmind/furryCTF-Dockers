FROM python:3.14-slim

# 配置pip镜像
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

WORKDIR /app

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ /app/
COPY frontend/static/ /app/static/

EXPOSE 5000

CMD ["python", "app.py"]