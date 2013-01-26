#!/bin/bash

# Apache2
ln -s ~/Applications/Apache2 /usr/local/apache

# MySQL
ln -s ~/Applications/mysql-5.5.29 /usr/local/mysql
sudo ln -s /usr/local/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib

# PHP
php_dir="~/Applications/php-5.4.11"

# symlink php directory
ln -s ${php_dir}/ /usr/local/php

# symlink php binaries
ln -s ${php_dir}/bin/php         /usr/local/bin/php
ln -s ${php_dir}/bin/php-config  /usr/local/bin/php-config
ln -s ${php_dir}/bin/phar.phar   /usr/local/bin/phar
