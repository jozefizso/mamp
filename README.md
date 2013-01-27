Apache, MySQL, PHP
====================
This is repository with documentation of MAMP server installation in OS X 10.8. I use this configuration on my Mac Book (jozef-mbp).

## Versions

<table>
  <tr><th>Apache</th><td>2.4.3</td></tr>
  <tr><th>MySQL</th><td>5.5.29</td></tr>
  <tr><th>PHP</th><td>5.4.11</td></tr>
</table>


## Configuration documentation

Applications are installed in the **~/Applications/** folder and symblinked into apropriate directories in **/usr/local/**.

Configuration files:

* Apache: ~/Applications/Apache2/conf/httpd.conf
* MySQL: ~/Applications/mysql-5.5.29/my.cnf
* PHP: ~/Applications/php-5.4.11/php.ini

### Apache

Configured with PHP 5.4 support, virtual hosts and mod rewrite.
Vhosts are located at **/usr/local/apache/vhosts**. Use the `vhosts` script to add new virtual hosts.


### MySQL

Installed version: 5.5.29 (Oracle distribution)

MySQL binaries are installed at ~/Applications/mysql-5.5.29

This directory is aliased to **/usr/local/mysql**

MySQL daemon runs under the mysql/mysql user and group.
The installation was secured using the mysql_secure_installation script.

**libmysqlclient.18.dylib** library must me symlinked to **/usr/lib**

    sudo ln -s /usr/local/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib
    
### PHP

Installed version 5.4.11 at ~/Applications/php-5.4.11

<table>
  <tr><th>Alias</th><th>Target path</th></tr>
  <tr><td>/usr/local/php</td><td>~/Applications/php-5.4.11/</td></tr>
  <tr><td>/usr/local/bin/php</td><td>~/Applications/php-5.4.11/bin/php</td></tr>
</table>
