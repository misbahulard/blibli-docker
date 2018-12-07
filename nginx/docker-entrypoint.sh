#!/bin/sh

# params
WP_DB=${WP_DB:-"wordpress"}
WP_USER=${WP_USER:-"wpuser"}
WP_PWD=${WP_PWD:-"wpuser"}
DB_HOST=${DB_HOST:-"mariadb"}
PHP_HOST=${PHP_HOST:-"php"}
PHP_PORT=${PHP_PORT:-"9000"}

# update wp-config
sed -i s/database_name_here/$WP_DB/ /var/www/html/wp-config.php
sed -i s/username_here/$WP_USER/ /var/www/html/wp-config.php
sed -i s/password_here/$WP_PWD/ /var/www/html/wp-config.php
sed -i s/localhost/$DB_HOST/ /var/www/html/wp-config.php

# update nginx virtual host
sed -i s/php:9000/$PHP_HOST:$PHP_PORT/ /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"
