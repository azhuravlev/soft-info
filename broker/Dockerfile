FROM ruby:2.6.5-alpine3.10
MAINTAINER Alexey Zhuravlev <alexey.g.zhuravlev@gmail.com>
LABEL Description="Soft-info" Version="1.0"

ARG PACKAGES="libxslt libxml2 git mysql-dev openssl tzdata"
ARG DEV_PACKAGES="libxml2-dev libxslt-dev build-base linux-headers"

RUN apk --no-cache --update add $PACKAGES
RUN apk --no-cache --update add --virtual build-dependencies $DEV_PACKAGES

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN gem install bundler
ENV BUNDLE_GEMFILE=/app/Gemfile BUNDLE_JOBS=3 BUNDLE_PATH=/bundle NOKOGIRI_USE_SYSTEM_LIBRARIES=1
RUN bundle install
RUN apk del build-dependencies

COPY . .

EXPOSE 3000
