FROM golang:1.21 as builder
WORKDIR /app
COPY . .
RUN go mod init go-web-app && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/app .
COPY static ./static
EXPOSE 8080
CMD ["./app"]