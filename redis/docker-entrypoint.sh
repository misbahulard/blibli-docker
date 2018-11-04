#!/bin/sh
set -e

if [ "${1#-}" != $1 ] || [ "${1%.conf}" != "$1" ]; then
    set -- redis-server "$@"
fi

if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
    find . \! -user redis -exec chown redis '{}' +
    exec su-exec redis "$0" "$@"
fi

exec "$@"

