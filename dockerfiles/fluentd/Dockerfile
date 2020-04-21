FROM fluent/fluentd:latest

USER root
RUN apk update
RUN apk  --no-cache --update add --virtual build-dependencies sudo build-base ruby-dev git
RUN apk add nano curl libc-dev gcc make ruby-dev ruby bash

RUN gem install 'fluent-plugin-elasticsearch' 
RUN gem install 'fluent-plugin-grok-parser' 
RUN gem install 'fluent-plugin-mutate_filter' 
RUN gem install 'fluent-plugin-record-reformer'

RUN /usr/bin/fluent-gem install 'fluent-plugin-elasticsearch'
RUN /usr/bin/fluent-gem install 'fluent-plugin-grok-parser' 
RUN /usr/bin/fluent-gem install 'fluent-plugin-mutate_filter' 
RUN /usr/bin/fluent-gem install 'fluent-plugin-record-reformer'

RUN /usr/bin/fluent-gem update

# RUN gem sources -c \
#     && apk del build-dependencies \
#     && rm -rf /var/cache/apk/*

RUN mkdir -p /logs/positions/nginx/

CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT