#!/bin/bash

_HOSTNAME=client002

echo "$_HOSTNAME" > /etc/hostname
/bin/hostname -b $_HOSTNAME
cat > /etc/hosts << EOF
127.0.0.1	localhost
127.0.1.1	$_HOSTNAME
192.168.33.2	dc dc.openforce.org
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

apt-get update
apt-get install realmd adcli krb5-user smbclient ldap-utils nmap tshark tcpdump -y

cat > /etc/ldap/ldap.conf << EOF
BASE	DC=OPENFORCE,DC=ORG
URI	ldap://dc.openforce.org
EOF

echo "supersede domain-name 'openforce.org';" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name-servers 192.168.33.2;" >> /etc/dhcp/dhclient.conf

cat > /etc/resolv.conf << EOF
nameserver 192.168.33.2
search openforce.org
domain openforce.org
EOF

cat > /etc/krb5.conf << EOF
[libdefaults]
  default_realm = OPENFORCE.ORG
  dns_lookup_realm = false
  dns_lookup_kdc = true
EOF

#echo "UseDNS no" >> /etc/ssh/sshd_config
