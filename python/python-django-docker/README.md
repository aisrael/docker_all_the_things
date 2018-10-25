# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Python version: 3.7

#### Building the docker image

```
docker build -t python-django-docker .
```

#### Running using Docker

```
docker run -p 8000:8000 python-django-docker
```

#### Querying the API
```
$ curl -w "\n" http://localhost:8000/hello/
{"data": {"greeting": "Hello, World!"}}

$ curl -w "\n" http://localhost:8000/hello/\?who=Garci
{"data": {"greeting": "Hello, Garci!"}}
```
