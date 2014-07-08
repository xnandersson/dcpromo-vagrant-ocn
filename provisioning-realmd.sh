#!/bin/bash

#
# Add PPA for PackageKit
# Link: https://launchpad.net/~ximion/+archive/packagekit
#
#add-apt-repository ppa:ximion/packagekit
#apt-get update

_HOSTNAME=client007

echo "$_HOSTNAME" > /etc/hostname
/bin/hostname -b $_HOSTNAME
cat > /etc/hosts << EOF
127.0.0.1	localhost
127.0.1.1	$_HOSTNAME
#192.168.33.2	dc dc.openforce.org
192.168.33.100	$_HOSTNAME
EOF

cat > /etc/realmd.conf << EOF
[users]
default-home = /home/%U
default-shell = /bin/bash

[active-directory]
default-client = sssd
os-name = ELX
os-version = 14.04

[service]
automatic-install = yes

[openforce.org]
user-principal = yes 
automatic-id-mapping = no 
manage-system = no
fully-qualified-names = no
EOF

cat > /tmp/krb5-config.debconf << EOF
krb5-config krb5-config/default_realm string OPENFORCE.ORG
krb5-config krb5-config/kerberos_servers string dc.openforce.org
krb5_config krb5-config/admin_server string dc.openforce.org
EOF
/usr/bin/debconf-set-selections /tmp/krb5-config.debconf


#echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list.d/ddebs.list
#echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse
#deb http://ddebs.ubuntu.com $(lsb_release -cs)-security main restricted universe multiverse
#deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" | \
#sudo tee -a /etc/apt/sources.list.d/ddebs.list
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 428D7C01
#apt-get install realmd-dbgsym adcli-dbgsym krb5-user smbclient ldap-utils nmap tshark tcpdump -y
#echo "deb http://archive.ubuntu.com/ubuntu/ trusty-proposed restricted main multiverse universe" >> /etc/apt/sources.list
apt-get update
apt-get install realmd adcli krb5-user smbclient ldap-utils nmap tshark tcpdump -y

#
# As realmd 0.15.0 is broken, we must replace with our own
# compiled binary.
#
#cp /vagrant/build/realmd /usr/lib/realmd/

cat > /etc/ldap/ldap.conf << EOF
BASE	DC=OPENFORCE,DC=ORG
URI	ldap://dc.openforce.org
EOF

echo "supersede domain-name 'openforce.org';" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name-servers 192.168.33.2;" >> /etc/dhcp/dhclient.conf

cat > /etc/resolv.conf << EOF
nameserver 192.168.33.5
nameserver 192.168.1.1
search openforce.org
domain openforce.org
EOF

cat > /etc/krb5.conf << EOF
[libdefaults]
  default_realm = OPENFORCE.ORG
  dns_lookup_realm = false
  dns_lookup_kdc = true
EOF
#
# PackageKit
#   apt-get install packagekit && killall aptd
#
# Join:
#realm -v join --client-software=sssd --membership-software=adcli OPENFORCE.ORG
#
# /usr/share/lightdm/lightdm.conf.d/50-ubuntu
#   greeter-show-manual-login=true 
#
# /etc/sssd/sssd.conf
#   create_homedir = True
#   access_provider = permit
#
# /etc/pam.d/common-session (BEFORE row with pam_sss.so)
#   session required        pam_mkhomedir.so umask=0022 skel=/etc/skel/
#
# /etc/ssh/sshd_config (Make sure home directory is created)
#   AllowGroups ssh-allowed group1 group2
#
# https://wiki.ubuntu.com/LightDM
