#!/bin/bash

echo "Client Provisioning"
cat > /tmp/krb5-config.debconf << EOF
krb5-config krb5-config/default_realm string OPENFORCE.ORG
krb5-config krb5-config/kerberos_servers string dc.openforce.org
krb5_config krb5-config/admin_server string dc.openforce.org
EOF

apt-get update
apt-get install adcli -y
apt-get install realmd -y
apt-get install krb5-user -y

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

