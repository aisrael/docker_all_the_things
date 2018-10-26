FROM clux/muslrust as builder
WORKDIR /usr/src/app

COPY Cargo.lock Cargo.lock
COPY Cargo.toml Cargo.toml
COPY src src

RUN cargo build --release

FROM alpine
COPY --from=builder /usr/src/app/target/x86_64-unknown-linux-musl/release/rust-api-docker hello-api
ENTRYPOINT ["./hello-api"]
