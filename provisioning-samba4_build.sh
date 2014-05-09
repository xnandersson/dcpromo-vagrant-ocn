#!/bin/bash
#
# Get Source code
#
git clone https://github.com/openchange/openchange.git
# 
# Install build dependencies
#
apt-get update
apt-get build-dep samba
apt-get build-dep openchange
#
# libtevent must be removed as it collides with newer version part of samba4
#
dpkg --remove libtevent-dev
#
# Some prerequisites
#
echo "/usr/local/samba/lib" > /etc/ld.so.conf.d/samba4.conf
echo 'export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/samba/lib/pkgconfig' >> ~/.bashrc
echo 'export PYTHONPATH=$PYTHONPATH:/usr/local/samba/lib/python2.6/site-packages' >> ~/.bashrc
source ~/.bashrc
#
# Compile Samba4
#
cd openchange
make samba-git
ldconfig
#
# Compile OpenChange
#
./autogen.sh && ./configure --prefix=/usr/local/samba
make
#
# Install
#
make install
ldconfig
