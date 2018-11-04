FROM alpine:3.8

LABEL maintainer="Misbahul Ardani <misbahulard@gmail.com>"

ENV REDIS_VERSION 4.0.11
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-4.0.11.tar.gz


RUN apk add --no-cache \
        'su-exec>=0.2' \
        tzdata

RUN apk add --no-cache --virtual .build-deps \
        coreutils \
        gcc \
        jemalloc-dev \
        linux-headers \
        make \
        musl-dev \
    && addgroup -S redis \
    && adduser -S -s /sbin/nologin -G redis redis \
    && wget -O redis.tar.gz $REDIS_DOWNLOAD_URL \
    && mkdir -p /usr/src/redis \
    && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
    && rm redis.tar.gz \
    && sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' /usr/src/redis/src/server.h \
    && make -C /usr/src/redis \
    && make -C /usr/src/redis install \
    && rm -rf /usr/src/redis \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    \
    && apk add --no-cache --virtual .redis-rundeps $runDeps \
    && apk del .build-deps \
    && mkdir /data \
    && chown redis:redis /data

VOLUME /data
WORKDIR /data
EXPOSE 6379

COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["redis-server"]
