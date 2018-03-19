FROM golang:1.10.0-alpine3.7 as builder
WORKDIR /go/github.com/aisrael/go-hello-docker
COPY hello.go .
RUN go build -ldflags "-s -w" hello.go

FROM alpine:3.7
WORKDIR /usr/src/app
COPY --from=builder /go/github.com/aisrael/go-hello-docker/hello .
ENTRYPOINT ["/usr/src/app/hello"]
