FROM python:3.7-alpine

COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

RUN mkdir -p /usr/src/app
COPY . /usr/src/app

WORKDIR /usr/src/app
CMD gunicorn hello_world.wsgi:application -b 0.0.0.0:8000
