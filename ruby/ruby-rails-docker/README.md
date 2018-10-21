# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: 2.5.3

#### Building the docker image

```
docker build -t ruby-rails-docker .
```

#### Running using Docker

##### First, run PostgreSQL

```
docker run --name postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=app_production -e POSTGRES_USER=app postgres:9.6
```

##### Then, run the app

```
docker run --link postgres -p 3000:3000 -e APP_DATABASE_PASSWORD=secret ruby-rails-docker
```
