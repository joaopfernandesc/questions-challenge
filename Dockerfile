FROM ruby:2.6.5-alpine

RUN apk update && apk upgrade && apk add ruby ruby-json ruby-io-console ruby-bundler ruby-irb ruby-bigdecimal tzdata && apk add nodejs && apk add --update npm && apk add curl-dev ruby-dev build-base libffi-dev && apk add build-base libxslt-dev libxml2-dev ruby-rdoc mysql-dev
RUN apk add git
RUN apk update && apk add curl && apk add bash

RUN mkdir /app
WORKDIR /app

COPY Gemfile ./
RUN gem install ovirt-engine-sdk -v '4.3.0' --source 'https://rubygems.org/'
RUN gem install bundler
RUN bundle install 

COPY . .

EXPOSE 3000

ENTRYPOINT ["sh", "./config/docker/startup.sh"]
