FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod .
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o webapp .

FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/webapp .
COPY --from=builder /app/static ./static
EXPOSE 8080
CMD ["./webapp"]