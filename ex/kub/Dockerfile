# ---------- Build stage ----------
FROM alpine:latest as builder
RUN apk add --no-cache build-base musl-dev

WORKDIR /app
COPY app/main.c .

# Compile statically using musl
RUN gcc -static -o server main.c

# ---------- Runtime stage ----------
FROM scratch

COPY --from=builder /app/server /server

EXPOSE 8080
ENTRYPOINT ["/server"]
    