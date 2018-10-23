FROM ruby:2.5.3-alpine
EXPOSE 4567
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app/
RUN bundle install
ENTRYPOINT ["bundle", "exec", "ruby", "app/api.rb"]
