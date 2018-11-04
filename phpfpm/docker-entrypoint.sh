#!/bin/sh

if [ ! -z "$USER_REDIS" ]; then
    sed -i s/"session.save_handler = files"/"session.save_handler = redis"/ /etc/php7/php.ini
fi  

exec php-fpm7 -F
