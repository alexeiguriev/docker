# Use a minimal base image with build tools
FROM gcc:12 as builder

# Create app directory
WORKDIR /usr/src/app

# Copy source and compile
COPY app/main.c .
RUN gcc -o server main.c

# Use a lightweight runtime image
FROM debian:bullseye-slim

# Copy compiled binary
COPY --from=builder /usr/src/app/server /usr/local/bin/server

# Expose the port the server listens on
EXPOSE 8080

# Run the server
CMD ["server"]
