#!/bin/bash

# PHP /  MYSQL INSTALL SCRIPT
# ------------------------------
# This script works together with the compile_apache.sh script.
# You can rerun this script and reinstall php/apache/mysql, the 
# htdocs won't be removed.  
#
#
# DOWNLOAD ALL SOURCES
# ----------------------
# - xz-5.0.4.tar.gz : http://tukaani.org/xz/
# - ... see the sources list for what version you need
#
#
# INSTALL
# -------
# 1) make sure to install apache first using the ./compile_apache.sh script
#
# 2) execute:
#    $ ./compile_php.sh  # <-- yes necessary
#    $ ./compile_php.sh png
#    $ ./compile_php.sh jpg
#    $ ./compile_php.sh freetype
#    $ ./compile_php.sh gettext
#    $ ./compile_php.sh curl
#    $ ./compile_php.sh xz
#    $ ./compile_php.sh xml
#    $ ./compile_php.sh mysql
#    $ ./compile_php.sh php
#
# 3) Copy the file: php.ini-development to ~/Applications/Apache2/php/lib/php.ini
#
#
# 4) Open ~/Applications/Apache2/conf/httpd.conf
#    check/change/add: 
#
#    - Load the php module:
#      LoadModule php5_module  modules/libphp5.so
#      LoadModule vhost_alias_module modules/mod_vhost_alias.so
#
#    - Hostname: 
#      ServerName localhost:80
#
#    - Virtual hosts (uncomment at the bottom):
#      Include conf/extra/httpd-vhosts.conf
#
#    - Load php files:
#       <FilesMatch "\.ph(p[2-6]?|tml)$">
#        SetHandler application/x-httpd-php
#       </FilesMatch>
#
#    - Make sure index.php is loaded
#      <IfModule dir_module>
#         DirectoryIndex index.php index.html
#      </IfModule>
#
# 5) Open ~/Applications/Apache2/conf/extra/httpd-vhosts.conf
#    configure as you like; here is an example with using vhost aliases
#
#           <VirtualHost *:80>
#                   ServerName localhost    
#                   ServerAlias *.localhost
#                   UseCanonicalName off
#                   VirtualDocumentRoot /Users/roxlu/Applications/Apache2/htdocs/%1/html/
#                   <Directory />
#                           AllowOverride All
#                           Order allow,deny
#                           allow from all
#                   </Directory>
#           </VirtualHost>
#
# 6) Install PHPMyadmin
#    - Download the english version, extract it into a vhost dir
#    - Copy config.sample.inc.php to config.inc.php
#    - Edit:
#      $cfg['Servers'][$i]['auth_type'] = 'config';
#      $cfg['Servers'][$i]['user'] = 'root';
#      $cfg['Servers'][$i]['password'] = 'somepassword';
#   
# 
# 7) Configure MySQL
#    - Copy the file: 
#     
#               ~/Applications/MySQL/scripts/mysql_install_db, to  ~/Application/MySQL/
#      
#      then execute it: 
#      ./mysql_install_db
#
#    - Go to: ~/Applications/MySQL/
#      $ sudo chmod -R 777 *
#    - Copy the file from this build directory:
#
#                ./mysql/compile/support-files/my-medium.cf to:  ~/Application/MySQL/my.cnf
#
#    - Edit the ~/Application/MySQL/my.cnf
#
#      [mysqld]
#      datadir=/Users/roxlu/Applications/MySQL/data/
#
#    - reset my.cnf permission:
#      $ chmod 755 ~/Applications/MySQL.my.cnf
#
#    - Start MySQL: 
#      $ cd ~/Applications/MySQL
#      $ sudo ./bin/mysqld_safe
#       
#    - Set root password (in other terminal)
#      $ cd ~/Applications/MySQL
#      $ ./bin/mysqladmin -u root password 'YOUR_PASSWORD'
#      $ ./bin/mysqladmin -u root -h roxlus-iMac.local password 'YOUR_PASSWORD' #<-- this failed, but I can still login
#   
#   
#    - MySQL STARTUP SCRIPT
#      --------------------
#      - Download the DMG version of MySQL from: http://dev.mysql.com/downloads/mysql/
#        (Select Mac OS X, + the DMG version)
#
#      - Open the DMG and click on the MySQLStartupItem.pkg
#
#      - This will install a startup script in: 
#        /Library/StartupItems/MySQLCOM/      
#
#      - To make this script work, we need to create a symbolic link:
#        $ sudo ln -s /Users/roxlu/Applications/MySQL /usr/local/mysql
#       
#      - It needs a var dir to:
#        $ cd ~/Applications/MySQL
#        $ ls -s data var
#
#
# 8) APACHE STARTUP SCRIPT
#    ---------------------
#    - Create a new file (as root):
#      $ emacs /System/Library/LaunchDaemons/com.apollomedia.apache2.plist
#
#    - Copy this contents into it (adjust path where necessary): 
#
#         <?xml version="1.0" encoding="UTF-8"?>
#         <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#         <plist version="1.0">
#         <dict>
#           <key>Label</key>
#           <string>com.apollomedia.apache2</string>
#           <key>ProgramArguments</key>
#           <array>
#             <string>/Users/roxlu/Applications/Apache2/bin/apachectl</string>
#             <string>start</string>
#           </array>
#           <key>RunAtLoad</key>
#           <true/>
#         </dict>
#         </plist>
# 
#     - Now load this file:
#       $ sudo launchctl load /System/Library/LauncDaemons/com.apollomedia.apache2.plist
#
#     - Start apache
#       $ sudo launchctl start com.apollomedia.apache2
#
dir=${PWD}
cd
home=${PWD}
cd ${dir}

builddir=${PWD}/build/
bd=${builddir}
apache_dir=${home}/Applications/Apache2
mysql_dir=${home}/Applications/MySQL

png_src="libpng-1.5.13.tar.gz"
jpg_src="jpegsrc.v8d.tar.gz"
ft_src="freetype-2.4.11.tar.gz"
gettext_src="gettext-0.18.2.tar.gz"
curl_src="curl-7.28.1.tar.gz"
php_src="php-5.4.10.tar.gz"
xz_src="xz-5.0.4.tar.gz"
xml_src="libxml2-2.8.0.tar.gz" # 2.9 has a bug:  http://stackoverflow.com/questions/12484664/what-am-i-doing-wrong-when-installing-lxml-on-mac-os-x-10-8-1
mysql_src="mysql-5.5.29.tar.gz" # go to the downlaod page and select "source" from the drop down

found_sources=1
check_source() {
    if [ ! -f "${1}" ] ; then
        echo "Download: ${1}" 
        found_sources=0
    else
        echo "FOUND: ${1}"
    fi
}

check_source ${png_src}
check_source ${jpg_src}
check_source ${ft_src}
check_source ${curl_src}
check_source ${php_src}
check_source ${xml_src}
check_source ${xz_src}
check_source ${mysql_src}

if [ ${found_sources} = 0 ] ; then
    echo "First download sources"
    exit
fi

if [ ! -d "png" ] ; then 
    tar -zxvf ${png_src} && mv ${png_src%.tar.gz} png
fi

if [ ! -d "jpg" ] ; then
    tar -zxvf ${jpg_src} && mv jpeg-8d jpg
fi

if [ ! -d "freetype" ] ; then
    tar -zxvf ${ft_src} && mv ${ft_src%.tar.gz} freetype
fi
if [ ! -d "gettext" ] ; then
    tar -zxvf ${gettext_src} && mv ${gettext_src%.tar.gz} gettext 
fi
if [ ! -d "curl" ] ; then
    tar -zxvf ${curl_src} && mv ${curl_src%.tar.gz} curl
fi
if [ ! -d "php" ] ; then
    tar -zxvf ${php_src} && mv ${php_src%.tar.gz} php
fi
if [ ! -d "xml" ] ; then
    tar -zxvf ${xml_src} && mv ${xml_src%.tar.gz} xml
fi
if [ ! -d "xz" ] ; then 
    tar -zxvf ${xz_src} && mv ${xz_src%.tar.gz} xz
fi
if [ ! -d "mysql" ] ; then 
    tar -zxvf ${mysql_src} && mv ${mysql_src%.tar.gz} mysql
fi

if [ "$1" = "png" ] ; then
    cd png
    ./configure --prefix=${builddir} --enable-shared=no --enable-static=yes
    make
    make install
    rm ${bd}/lib/*.dylib
fi

if [ "$1" = "jpg" ] ; then
    set -x
    cd jpg
    ./configure --prefix=${builddir} --enable-shared=no --enable-static=yes
    make
    make install
    rm ${bd}/lib/*.dylib
fi

if [ "$1" = "freetype" ] ; then
    cd freetype
    ./configure --prefix=${builddir} --enable-shared=no --enable-static=yes
    make
    make install
    rm ${bd}/lib/*.dylib
fi

if [ "$1" = "gettext" ] ; then
    cd gettext
    ./configure --prefix=${builddir} --enable-shared=no --enable-static=yes
    make
    make install
    rm ${bd}/lib/*.dylib
fi

if [ "$1" = "curl" ] ; then
    cd gettext
    ./configure --prefix=${builddir} --enable-shared=no --enable-static=yes
    make
    make install
    rm ${bd}/lib/*.dylib
fi

if [ "$1" = "xz" ] ; then
    cd xz
    ./configure --prefix=${builddir} --enable-shared=no --enable-static=yes
    make
    make install
    rm ${bd}/lib/*.dylib
fi


if [ "$1" = "xml" ] ; then
    cd xml
    ./configure --prefix=${builddir} --enable-shared=no --enable-static=yes --with-lzma=${bd}
    make
    make install
    rm ${bd}/lib/*.dylib
fi

if [ "$1" = "mysql" ] ; then
    cd mysql
    if [ ! -d compile ] ; then 
        mkdir compile
    fi
    cd compile
    cmake -DCMAKE_INSTALL_PREFIX=${mysql_dir} ../  
    make 
    make install
    rm ${mysql_dir}/lib/*.dylib
fi

if [ "$1" = "php" ] ; then 

    lib_dir=${dir}/build/lib/
    dest_dir=${apache_dir}/php
    export PATH="${builddir}/bin/:${PATH}"
    export CFLAGS="-I${builddir}include/"
    export CPPFLAGS=${CFLAGS}
    export CXXFLAGS=${CPPFLAGS}
    export LDFLAGS="-L${builddir}/lib/ -lxml2 -llzma -lbz2 -lssl -lcrypto -lresolv" 
    export LIBXML2_VERSION=2.8.0

    if [ ! -d $dest_dir ] ; then
	mkdir -p ${dest_dir}
    fi

    cd php
    ./configure --prefix=${dest_dir} \
	--without-pear \
	--with-apxs2=${apache_dir}/bin/apxs \
	--with-mysql=${mysql_dir} \
	--with-pdo-mysql=${mysql_dir}/bin/mysql_config \
	--with-png-dir=${bd} \
        --with-jpeg-dir=${bd} \
	--with-freetype-dir=${bd} \
        --with-curl=${bd} \
        --with-libxml-dir=${bd} \
	--with-zlib \
	--with-gd \
	--with-mhash \
	--with-ldap \
	--with-iconv \
	--enable-mbstring \
	--enable-ftp \
	--enable-exif \
	--enable-bcmath \
	--enable-soap \
        --enable-shared=no \
        --enable-static=yes
    make 
    make install
fi

if [ "$1" = "phpmyadmin" ] ; then
    mv ${dir}/phpmyadmin ${home}/Applications/Apache2/htdocs
fi
