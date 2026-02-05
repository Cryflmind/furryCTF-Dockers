FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
