#!/bin/bash
apt-get update
apt-get install git -y
apt-get build-dep realmd -y
git clone git://anongit.freedesktop.org/realmd/realmd
sed s/"1.13 1.12"/"1.14 1.13 1.12"/ realmd/autogen.sh > /tmp/$$
cp /tmp/$$ realmd/autogen.sh
rm /tmp/$$
cd realmd
sh autogen.sh \
  --without-systemd-journal \
  --without-systemd-unit-dir \
  --sysconfdir=/etc \
  --libdir=/usr/lib
make
