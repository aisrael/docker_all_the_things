FROM clux/muslrust as builder
WORKDIR /usr/src/app

COPY Cargo.lock Cargo.lock
COPY Cargo.toml Cargo.toml
COPY main.rs main.rs

RUN cargo clean
RUN cargo build --release

FROM alpine
COPY --from=builder /usr/src/app/target/x86_64-unknown-linux-musl/release/hello .
ENTRYPOINT ["./hello"]
