FROM golang:1.9.4-alpine3.7 as builder
WORKDIR /go/github.com/aisrael/go-api-docker
COPY api.go .
RUN go build -ldflags "-s -w" api.go

FROM alpine:3.7
EXPOSE 8080
WORKDIR /usr/src/app
COPY --from=builder /go/github.com/aisrael/go-api-docker/api .
ENTRYPOINT [ "/usr/src/app/api"]
