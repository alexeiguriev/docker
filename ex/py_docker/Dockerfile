# Use Debian as the base image
FROM debian:latest

# Install Python and dependencies
RUN apt-get update && apt-get install -y python3 python3-pip

# Set the working directory inside the container
WORKDIR .

# Copy the Python app into the container
COPY app.py .

# Run the Python app when the container starts
CMD ["python3", "-u", "app.py"]
