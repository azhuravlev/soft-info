FROM ruby:2.6.5-alpine3.10
MAINTAINER Alexey Zhuravlev <alexey.g.zhuravlev@gmail.com>
LABEL Description="Messagist for sotf-info" Version="3.0"

RUN apk add --no-cache git

ADD . /worker

WORKDIR /worker

RUN apk --update add --virtual build_deps \
                               build-base \
                               ruby-dev \
                               libc-dev \
                               linux-headers \
                               openssl-dev && \
    bundle --jobs=4 --retry=3 && \
    apk del build_deps

CMD foreman start