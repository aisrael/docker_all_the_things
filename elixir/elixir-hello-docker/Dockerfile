# Build stage
FROM elixir:1.7.3 as mixer
COPY . /usr/src/app
WORKDIR /usr/src/app
ENV MIX_ENV=prod
RUN mix escript.build

# Deployed container
FROM alpine:3.8
WORKDIR /usr/src/app
RUN apk --update add erlang && rm -rf /var/cache/apk/*
# ENV LC_ALL="C.UTF-8"docker
COPY --from=mixer /usr/src/app/hello /usr/src/app
ENTRYPOINT [ "/usr/src/app/hello" ]
