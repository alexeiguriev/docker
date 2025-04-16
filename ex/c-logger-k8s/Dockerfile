# ---------- Build stage ----------
    FROM alpine:latest AS builder
    RUN apk add --no-cache build-base musl-dev libmicrohttpd-dev
    
    WORKDIR /app
    COPY app/logger.c .
    
    # Compile statically with musl and libmicrohttpd
    RUN gcc -static -o logger logger.c -lmicrohttpd
    
    # ---------- Runtime stage ----------
    FROM scratch
    
    COPY --from=builder /app/logger /logger
    
    EXPOSE 8081
    ENTRYPOINT ["/logger"]
    