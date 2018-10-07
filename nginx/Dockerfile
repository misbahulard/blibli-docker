FROM alpine:3.8

LABEL maintainer="Misbahul Ardani <misbahulard@gmail.com>"

ENV NGINX_VERSION 1.15.4
ENV WORDPRESS_VERSION 4.9.8
ENV WP_DB wordpress
ENV WP_USER wpuser
ENV WP_PWD wpuser
ENV DB_HOST mariadb

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        linux-headers \
        curl \
        gd-dev \
        geoip-dev \
        libc-dev \
        libxslt-dev \
        openssl-dev \
        pcre-dev \
        zlib-dev \
    && addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    && mkdir -p /tmp/src \
    && tar -xzC /tmp/src -f nginx.tar.gz \
    && rm nginx.tar.gz \
    && CONFIG="\
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-http_v2_module \
    " \
    && cd /tmp/src/nginx-$NGINX_VERSION \
    && ./configure $CONFIG \
    && make \
    && make install \
    && rm -rf /etc/nginx/html \
    && mkdir /etc/nginx/conf.d \
    && mkdir -p /var/www/html \
    && rm -rf /tmp/src \
    && cd / \
    && curl -fSL https://wordpress.org/wordpress-$WORDPRESS_VERSION.tar.gz -o wordpress.tar.gz \
    && tar -xzC /var/www/html --strip-components=1 -f wordpress.tar.gz \
    && rm -rf wordpress.tar.gz \
    \
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .nginx-rundeps $runDeps \
    && apk del .build-deps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin \
    \
    # forward request and error logs to docker log collector
    \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    \
    # set wp-config
    \
    && mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php \
    && sed -i s/database_name_here/$WP_DB/ /var/www/html/wp-config.php \
    && sed -i s/username_here/$WP_USER/ /var/www/html/wp-config.php \
    && sed -i s/password_here/$WP_PWD/ /var/www/html/wp-config.php \
    && sed -i s/localhost/$DB_HOST/ /var/www/html/wp-config.php

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
