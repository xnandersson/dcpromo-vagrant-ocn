#!/bin/bash
#
# Update repo
#
apt-get update
#
# Get source code
#
apt-get install git -y
git clone git://anongit.freedesktop.org/realmd/realmd
#
# Get build dependencies
#
apt-get build-dep realmd -y
#
# We have automake 1.14 (newer than latest in source code), 
# so we must add it to autogen.sh, if not we get error.
#
sed s/"1.13 1.12"/"1.14 1.13 1.12"/ realmd/autogen.sh > /tmp/$$
cp /tmp/$$ realmd/autogen.sh
rm /tmp/$$
#
# Configure and make
#
cd realmd
sh autogen.sh \
  --without-systemd-journal \
  --without-systemd-unit-dir \
  --sysconfdir=/etc \
  --libdir=/usr/lib
make
mkdir /vagrant/build
cp realmd /vagrant/build
