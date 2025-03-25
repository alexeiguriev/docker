# Use Ubuntu as the base image
# FROM ubuntu:latest
FROM debian:latest

# Update package lists and install GCC
RUN apt-get update && apt-get install -y gcc

# Set the working directory inside the container
WORKDIR .

# Copy the C source code from the current directory into the container
COPY main.c .

# Compile the C program (main.c is now in the container)
RUN gcc -o my_app main.c

# Command to run the C program when the container starts
CMD ["./my_app"]
