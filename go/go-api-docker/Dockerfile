FROM golang:1.11.1-alpine3.8 as builder
WORKDIR /go/github.com/aisrael/go-api-docker
COPY api.go .
RUN go build -ldflags "-s -w" api.go

FROM alpine:3.8
EXPOSE 8080
WORKDIR /usr/src/app
COPY --from=builder /go/github.com/aisrael/go-api-docker/api .
ENTRYPOINT [ "/usr/src/app/api"]
