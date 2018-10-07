#!/bin/sh

# params
MYSQL_ROOT_PWD=${MYSQL_ROOT_PWD:-"mysql"}
MYSQL_USER=${MYSQL_USER:-"wpuser"}
MYSQL_USER_PWD=${MYSQL_USER_PWD:-"wpuser"}
MYSQL_USER_DB=${MYSQL_USER_DB:-"wordpress"}

if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
    echo '[i] MySQL directory already exist, skipping creation'
else
    echo '[i] MySQL data directory not found, creating initial DBs'

    chown -R mysql:mysql /var/lib/mysql

    # update mysql.cnf
    # sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

    # init database
    echo '[i] Initializing database'
    mysql_install_db --user=mysql > /dev/null
    echo '[i] Database initialized'

    echo "[i] MySQL root password: $MYSQL_ROOT_PWD"

    # create temp file
    tfile=`mktemp`
    
    # save sql
    echo "Create temp file: $tfile"
    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PWD' WITH GRANT OPTION;
GRANT ALL ON *.* TO ${MYSQL_USER}@'localhost*' IDENTIFIED BY '${MYSQL_USER_PWD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_USER_PWD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO ${MYSQL_USER}@'*' IDENTIFIED BY '${MYSQL_USER_PWD}' WITH GRANT OPTION;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $MYSQL_USER_DB CHARACTER SET utf8 COLLATE utf8_general_ci;
EOF

    # info user
    echo "[i] Creating new DB: $MYSQL_USER_DB"
    echo "[i] Creating new User: $MYSQL_USER"
    echo "[i] Password: $MYSQL_USER_PWD"

    # run sql in tempfile
    echo "[i] run tempfile: $tfile"
    /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
    rm -f $tfile
fi

echo "[i] Start mysql"
exec /usr/bin/mysqld --user=mysql --console

