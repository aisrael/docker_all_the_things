FROM ysbaddaden/crystal-alpine:0.24.2 as compiler
WORKDIR /usr/src/app
COPY hello.cr /usr/src/app/
RUN crystal build --release --static hello.cr

FROM alpine:3.7
RUN apk add --update pcre gc libevent libgcc
WORKDIR /usr/src/app
COPY --from=compiler /usr/src/app/hello /usr/src/app/
ENTRYPOINT ["/usr/src/app/hello"]
