#!/bin/sh

# COMPILE AND INSTALL APACHE
#
# Used to install a httpd-2.4.3 on osx mountain lion. 
# When you want to upgrade yo can just change the source version 
# and recompile. Apache will not remove configuration + htdocs
# You can also easily update php.

dir=${PWD}
cd
home=${PWD}
cd ${dir}

bd=${PWD}/build/
apache_dir=${home}/Applications/Apache2

# Check if the source file can be found
http_src="httpd-2.4.3.tar.gz"
pcre_src="pcre-8.32.tar.gz"

found_sources=1
check_source() {
    if [ ! -f "${1}" ] ; then 
        found_sources=0
        echo "Download: ${1}"
    else
        echo "Found: ${1}"
    fi
}

check_source ${http_src}
check_source ${pcre_src}

if [ ${found_sources} = 0 ] ; then 
    echo "First download sources"
    exit
fi


if [ ! -d http ] ; then 
    tar -zxvf ${http_src} && mv ${http_src%.tar.gz} http
fi

if [ ! -d pcre ] ; then 
    tar -zxvf ${pcre_src} && mv ${pcre_src%.tar.gz} pcre
fi

if [ "$1" = "pcre" ] ; then 
    cd pcre
    ./configure --prefix=${bd} --enable-shared=no --enable-static=yes
    make clean
    make 
    make install
fi

if [ "$1" = "apache" ] ; then
    if [ -d ${home}/Applications/Apache2 ] ; then 
	mkdir -p ${home}/Applications/Apache2 
    fi
    export PATH="${bd}/bin:${PATH}"
    export CFLAGS="-I${bd}/include/"
    export CPPFLAGS=${CFLAGS}
    export LDFLAGS="-L${bd}/lib/"
    
    cd http
    ./configure --prefix=${apache_dir} \
        --with-ssl=/usr \
        --enable-ssl \
        --enable-dav \
        --enable-cache \
        --enable-logio \
        --enable-deflate \
        --enable-so
    
    make
    make install
fi
