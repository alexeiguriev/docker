# ---------- Build stage ----------
    FROM alpine AS builder

    RUN apk add --no-cache build-base musl-dev libmicrohttpd-dev
    
    WORKDIR /app
    COPY app/logger.c .
    
    RUN gcc -o logger logger.c -lmicrohttpd
    
    # ---------- Runtime stage ----------
    FROM alpine
    
    RUN apk add --no-cache libmicrohttpd
    
    COPY --from=builder /app/logger /logger
    ENTRYPOINT ["/logger"]
    
