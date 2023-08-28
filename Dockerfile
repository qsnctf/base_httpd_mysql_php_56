FROM php:5.6-apache

LABEL Organization="qsnctf" Author="M0x1n <lqn@sierting.com>"


COPY files /tmp/

RUN sed -i 's/deb.debian.org/mirrors.nju.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.nju.edu.cn/g' /etc/apt/sources.list \
    && apt-get update -y && apt-get install -y net-tools wget mysql-client mariadb-server \
    && docker-php-source extract \
    && docker-php-ext-install mysql mysqli pdo_mysql \
    && docker-php-source delete \
    && mysql_install_db --user=mysql --datadir=/var/lib/mysql \
    && sh -c 'mysqld_safe &' \
    && sleep 5s \
    && mysqladmin -uroot password 'root' \
    # Fix: Update all root password
    && mysql -uroot -proot -e "UPDATE mysql.user SET Password=PASSWORD('root') WHERE user='root';" \
    && mysql -uroot -proot -e "create user ping@'%' identified by 'ping';" \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && sed -i -e 's/display_errors.*/display_errors = Off/' /usr/local/etc/php/php.ini \
    && mv /tmp/flag.sh /flag.sh \
    && mv /tmp/docker-php-entrypoint /usr/local/bin/docker-php-entrypoint \
    && mv /tmp/apache2.conf /etc/apache2/apache2.conf \
    && chmod +x /usr/local/bin/docker-php-entrypoint \
    && mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    # clear
    && rm -rf /tmp/*


WORKDIR /var/www/html

COPY www /var/www/html/

EXPOSE 80

