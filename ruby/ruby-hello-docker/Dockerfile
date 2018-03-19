FROM ruby:2.5.0-alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY hello.rb /usr/src/app/
ENTRYPOINT ["ruby", "hello.rb"]
