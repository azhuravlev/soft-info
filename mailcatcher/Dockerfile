FROM ruby:2.6.5-alpine3.10
MAINTAINER Alexey Zhuravlev <alexey.g.zhuravlev@gmail.com>
LABEL Description="Dev mailcatcher" Version="1.0"

RUN apk add --no-cache sqlite-libs libstdc++
RUN apk add --no-cache --virtual build-dependencies build-base gcc sqlite-dev ca-certificates
RUN gem install mailcatcher -v 0.6.5 --no-doc
RUN apk del build-dependencies

# smtp port
EXPOSE 1025
# webserver port
EXPOSE 1080

CMD ["mailcatcher", "--no-quit", "--foreground", "--ip=0.0.0.0"]
