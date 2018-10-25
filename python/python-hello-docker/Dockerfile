FROM python:3.7-alpine

RUN mkdir -p /usr/src/app
COPY hello.py /usr/src/app

WORKDIR /usr/src/app
ENTRYPOINT ["python", "hello.py"]
