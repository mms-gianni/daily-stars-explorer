FROM golang:1.21.1-alpine as builder
WORKDIR /app
COPY main.go .
COPY otel_instrumentation ./otel_instrumentation
COPY go.mod .
COPY go.sum .
RUN go mod download
RUN go build -o gh_stats_app ./main.go

FROM alpine:latest AS runner
WORKDIR /home/app
COPY --from=builder /app/gh_stats_app .
EXPOSE 8080
ENTRYPOINT ["./gh_stats_app"]