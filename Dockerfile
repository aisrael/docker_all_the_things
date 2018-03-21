# Build stage
FROM elixir:1.6.0-alpine as builder

ENV APP_NAME=api
ENV MIX_ENV=prod

COPY . /src
WORKDIR /src

RUN echo $(cat mix.exs|grep version:|head -n1|awk -F: '{print $2}'|sed 's/[\",]//g'|tr -d '[[:space:]]') > .version

RUN rm -rf /src/_build \
 && mix local.hex --force \
 && mix local.rebar --force \
 && mix deps.get \
 && mix compile \
 && mix release --env=prod
RUN mkdir -p /app \
 && tar xzf /src/_build/prod/rel/api/releases/$(cat .version)/api.tar.gz -C /app

# Deployed container
FROM elixir:1.6.0-alpine

RUN apk --update add bash

COPY --from=builder /app /app

WORKDIR /app

ENTRYPOINT ["/app/bin/api"]
CMD ["foreground"]
