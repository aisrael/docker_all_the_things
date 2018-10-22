FROM golang:1.11.1-alpine3.8 as builder
RUN apk add --no-cache git curl \
    && rm -rf /var/cache/apk/*
RUN wget -qO- https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 > /usr/local/go/bin/dep \
    && chmod a+x /usr/local/go/bin/dep
RUN go get -v github.com/revel/revel \
    && go get -v github.com/revel/cmd/revel
RUN mkdir -p /go/src/github.com/aisrael/go-revel-docker
WORKDIR /go/src/github.com/aisrael/go-revel-docker
COPY . /go/src/github.com/aisrael/go-revel-docker
RUN revel package -a github.com/aisrael/go-revel-docker github.com/aisrael/go-revel-docker

FROM alpine:3.8
EXPOSE 9000
WORKDIR /go
COPY --from=builder /go/src/github.com/aisrael/go-revel-docker/go-revel-docker.tar.gz /go
RUN tar xvzf go-revel-docker.tar.gz
# revel package has a bug, see https://github.com/revel/revel/issues/1383
COPY run.sh /go
RUN chmod a+x /go/run.sh
ENTRYPOINT [ "/go/run.sh" ]
