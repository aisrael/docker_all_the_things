FROM golang:1.11.1-alpine3.8 as builder
WORKDIR /go/github.com/aisrael/go-hello-docker
COPY hello.go .
RUN go build -ldflags "-s -w" hello.go

FROM alpine:3.8
WORKDIR /usr/src/app
COPY --from=builder /go/github.com/aisrael/go-hello-docker/hello .
ENTRYPOINT ["/usr/src/app/hello"]
