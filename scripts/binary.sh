#!/bin/bash

cd /tmp

#if you have libmemcached-dev < 1.0.X need to run: sudo apt-get purge libmemcached-dev
apt-get install -y libevent-dev php5-dev php5-common php5-fpm
pecl install igbinary

#cant do sudo pecl install memcached-2.1.0 cuz it wont let me use igbinary
#compiling manually per http://www.neanderthal-technology.com/2011/11/ubuntu-10-install-php-memcached-with-igbinary-support/

#install libmemcached v 1.0.X for pecl memcached 2.1.0
libmemcached_ver="1.0.15"
wget https://launchpad.net/libmemcached/1.0/${libmemcached_ver}/+download/libmemcached-${libmemcached_ver}.tar.gz
tar -xzvf libmemcached-${libmemcached_ver}.tar.gz
cd libmemcached-${libmemcached_ver}/
./configure
make
make install
cd ../
rm -r libmemcached-${libmemcached_ver}

#install memcached PECL extension
pecl_memcached_ver="2.1.0"
pecl download memcached-${pecl_memcached_ver}
tar xzvf memcached-${pecl_memcached_ver}.tgz
cd memcached-${pecl_memcached_ver}/
phpize
./configure --enable-memcached-igbinary
make
make install
cd ..
rm -r memcached-${pecl_memcached_ver}

echo "extension=igbinary.so" > /etc/php5/fpm/conf.d/igbinary.ini
echo "extension=memcached.so" > /etc/php5/fpm/conf.d/memcached.ini