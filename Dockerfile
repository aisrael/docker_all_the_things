FROM ysbaddaden/crystal-alpine:0.24.2 as builder
RUN mkdir /src
WORKDIR /src
RUN apk update && apk add openssl-dev
COPY . /src/
RUN shards && crystal build --release src/api.cr

FROM alpine:3.7
EXPOSE 3000
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN apk add --update openssl pcre gc libevent libgcc
COPY --from=builder /src/api /usr/src/app/api
ENTRYPOINT [ "/usr/src/app/api"]
