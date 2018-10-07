FROM alpine:3.8

LABEL mainainer="Misbahul Ardani <misbahulard@gmail.com>"

ENV WORDPRESS_VERSION 4.9.8
ENV WP_DB wordpress 
ENV WP_USER wpuser
ENV WP_PWD wpuser
ENV DB_HOST mariadb

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
    && rm -rf /etc/php7/php-fpm.d/www.conf \
    && mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php \
    && sed -i s/database_name_here/$WP_DB/ /var/www/html/wp-config.php \
    && sed -i s/username_here/$WP_USER/ /var/www/html/wp-config.php \
    && sed -i s/password_here/$WP_PWD/ /var/www/html/wp-config.php \
    && sed -i s/localhost/$DB_HOST/ /var/www/html/wp-config.php

COPY docker.conf /etc/php7/php-fpm.d/docker.conf

EXPOSE 9000

CMD ["php-fpm7", "-F"]
