# ---------- Build stage ----------
    FROM alpine:latest AS builder
    RUN apk add --no-cache build-base libcurl curl-dev
    
    WORKDIR /app
    COPY app/main.c .
    
    RUN gcc -o server main.c -lcurl
    
    # ---------- Runtime stage ----------
    FROM alpine:latest
    RUN apk add --no-cache libcurl
    
    COPY --from=builder /app/server /server
    
    EXPOSE 8080
    ENTRYPOINT ["/server"]
    