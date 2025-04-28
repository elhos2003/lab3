FROM golang:1.21-alpine AS builder

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /app

COPY main.go .

RUN go mod init myapp && \
    go mod tidy && \
    go build -o myapp

    FROM alpine:3.19

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/myapp .

USER appuser

ENTRYPOINT ["./myapp"]
