FROM python:3.12-slim

WORKDIR /app
COPY app/logger.py .

RUN pip install flask

EXPOSE 8081
CMD ["python", "logger.py"]
