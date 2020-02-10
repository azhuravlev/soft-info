FROM ruby:2.6.5-alpine3.10
MAINTAINER Alexey Zhuravlev <alexey.g.zhuravlev@gmail.com>
LABEL Description="Messagist for sotf-info" Version="2.0"

RUN apk --update add --no-cache --virtual build-dependencies make gcc libc-dev

ADD Gemfile* ./
RUN bundle install

COPY . .

RUN apk del build-dependencies

CMD [ "bin/entry" ]
