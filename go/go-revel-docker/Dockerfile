FROM golang:1.9.4-alpine3.7
EXPOSE 9000

LABEL maintainer="kterada.0509sg@gmail.com"

RUN apk add --no-cache git curl \
    && rm -rf /var/cache/apk/*

RUN wget -qO- https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 > /usr/local/go/bin/dep \
    && chmod a+x /usr/local/go/bin/dep

RUN go get -v github.com/revel/revel \
    && go get -v github.com/revel/cmd/revel

RUN mkdir -p /go/src/github.com/aisrael/go-revel-docker
WORKDIR /go/src/github.com/aisrael/go-revel-docker

COPY . /go/src/github.com/aisrael/go-revel-docker/

CMD ["revel", "run", "github.com/aisrael/go-revel-docker"]
