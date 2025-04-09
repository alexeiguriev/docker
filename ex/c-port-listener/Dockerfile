# Use Alpine Linux as the base image
FROM alpine:latest

# Install GCC, libc-dev, and other dependencies needed to build the C application
RUN apk update && apk add --no-cache gcc libc-dev

# Set the working directory inside the container
WORKDIR .app

# Copy the current directory contents (including server.c and Dockerfile) into the container
COPY . .

# Compile the C program
RUN gcc -o server server.c

# Expose the port that the server will listen on
EXPOSE 8080

# Run the compiled server application
CMD ["./server"]
