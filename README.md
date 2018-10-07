Container based on Alpine 3.8 Linux

## Nginx

#### build image

```
$ docker build -t misbahulard/nginx .
```

#### parameter

* `NGINX_VERSION` : set nginx version - default "1.15.4"
* `WORDPRESS_VERSION` : set wordpress version - default "4.9.8"
* `WP_DB` : set database for wordpress - default "wordpress"
* `WP_USER` : set wordpress user - default "wpuser"
* `WP_PWD` : set wordpress user password - default "wpuser"
* `DB_HOST` : set database host - default "mariadb"

#### volume
* /var/www/html

#### run a default contaier

```
$ docker run --name nginx -p 8080:80 misbahulard/nginx
```

## PHP-FPM

php-fpm 7

#### build image

```
$ docker build -t misbahulard/phpfpm .
```

#### parameter

* `WORDPRESS_VERSION` : set wordpress version - default "4.9.8"
* `WP_DB` : set database for wordpress - default "wordpress"
* `WP_USER` : set wordpress user - default "wpuser"
* `WP_PWD` : set wordpress user password - default "wpuser"
* `DB_HOST` : set database host - default "mariadb"

#### volume
* /var/www/html

#### run a default contaier

```
$ docker run --name phpfpm misbahulard/phpfpm
```

## Mariadb

#### build image

```
$ docker build -t misbahulard/mariadb .
```

#### parameter

* `MYSQL_ROOT_PWD` : set mysql root password - default "mysql"
* `MYSQL_USER` : set new mysql user - default "wpuser"
* `MYSQL_USER_PWD` : set new mysql user password - default "wpuser"
* `MYSQL_USER_DB` : set new database - default "wordpress"

#### volume
* /var/lib/mysql

#### run a default contaier

```
$ docker run --name mariadb misbahulard/mariadb
```