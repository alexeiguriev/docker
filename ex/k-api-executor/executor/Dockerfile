# syntax=docker/dockerfile:1

# ✅ Base image
FROM python:3.12-slim

# ✅ Set working directory
WORKDIR /app

# ✅ Copy your application
COPY executor.py .

# ✅ Install Flask
RUN pip install flask
RUN apt update && apt install curl -y

# ✅ Set default command
CMD ["python", "executor.py"]
