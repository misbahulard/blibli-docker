FROM alpine:3.8

LABEL mainainer="Misbahul Ardani <misbahulard@gmail.com>"

ENV WORDPRESS_VERSION 4.9.8

RUN apk add --no-cache --virtual .php-deps \
        curl \
        php7 \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-fpm \
        php7-gd \
        php7-gettext \
        php7-json \
        php7-mcrypt \
        php7-mysqli \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-soap \
        php7-xmlreader \
        php7-xmlrpc \
        php7-zip \
    && mkdir -p /var/www/html \
    && curl -fSL https://wordpress.org/wordpress-$WORDPRESS_VERSION.tar.gz -o wordpress.tar.gz \
    && tar -xzC /var/www/html --strip-components=1 -f wordpress.tar.gz \
    && rm -rf wordpress.tar.gz \
    && mkdir -p /var/cache/nginx \
    && addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
    && rm -rf /etc/php7/php-fpm.d/www.conf

COPY docker.conf /etc/php7/php-fpm.d/docker.conf

EXPOSE 9000

CMD ["php-fpm7", "-F"]
