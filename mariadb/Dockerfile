FROM alpine:3.8

LABEL mainainer="Misbahul Ardani <misbahulard@gmail.com>"

RUN apk add --no-cache \
    mariadb \
    mariadb-client

COPY docker-entrypoint.sh /usr/local/bin

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]
