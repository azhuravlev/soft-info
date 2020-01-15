FROM ruby:2.6.5-alpine3.10
MAINTAINER Alexey Zhuravlev <alexey.g.zhuravlev@gmail.com>
LABEL Description="Soft-info" Version="1.0"

ARG PACKAGES="libxslt libxml2 git mysql-dev openssl tzdata"
ARG DEV_PACKAGES="libxml2-dev libxslt-dev build-base linux-headers"

RUN apk --no-cache --update add $PACKAGES \
 && apk --no-cache --update add --virtual build-dependencies $DEV_PACKAGES

WORKDIR /app

COPY Gemfile* ./
RUN gem install bundler && bundle install && apk del build-dependencies

COPY . .

EXPOSE 3000