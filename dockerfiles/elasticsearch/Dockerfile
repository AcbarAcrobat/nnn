# elastic Docker Copyright (C) 2019 elastic Inc. (License GPLv2)
ARG ELASTIC_VERSION=7.4.1
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VERSION}

COPY config/entrypoint.sh /entrypoint.sh 

RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["elasticsearch"]