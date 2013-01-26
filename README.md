Apache, MySQL, PHP
====================

**Configuration setup for jozef-mbp**

Applications are installed in the **~/Applications/** folder.

Configuration:

* Apache: ~/Applications/Apache2/conf
* MySQL: ~/Applications/mysql-5.5.29/my.cnf
* PHP: ~/Applications/php-5.4.11/conf



### MySQL

MySQL binaries are installed at ~/Applications/mysql-5.5.29

This directory is aliased to **/usr/local/mysql**

MySQL deamen runs under the mysql/mysql user and group.
The installation was secured using the mysql_secure_installation script.

**libmysqlclient.18.dylib** library must me symlinked to **/usr/lib**

    sudo ln -s /usr/local/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib