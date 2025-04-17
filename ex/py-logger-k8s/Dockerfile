FROM python:3.12-slim

WORKDIR /app
COPY app/logger.py .

RUN pip install flask

# Create logs directory
RUN mkdir /logs

# Make sure it's writable by default user
RUN chmod 777 /logs

EXPOSE 8081
CMD ["python", "logger.py"]
