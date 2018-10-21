FROM ruby:2.5.3-alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY hello.rb /usr/src/app/
ENTRYPOINT ["ruby", "hello.rb"]
