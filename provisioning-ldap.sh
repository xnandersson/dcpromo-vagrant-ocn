echo "Provisioning ldap"
echo "ldap.openforce.org" > /etc/hostname
/bin/hostname -b ldap.openforce.org
cat > /etc/hosts << EOF
127.0.0.1	localhost
127.0.1.1	ldap.openforce.org ldap
EOF
cat > /tmp/slapd.debconf << EOF
slapd slapd/password1 string Secret007!
slapd slapd/password2 string Secret007!
EOF
/usr/bin/debconf-set-selections /tmp/slapd.debconf
apt-get update
apt-get install sudo-ldap -y
apt-get install slapd ldap-utils sudo-ldap -y
cp /usr/share/doc/sudo-ldap/schema.OpenLDAP /etc/ldap/schema/sudo.schema
cat > /etc/ldap/ldap.conf << EOF
BASE	dc=openforce,dc=org
BINDDN	cn=admin,dc=openforce,dc=org
URI	ldap://localhost
EOF
#service slapd stop
#slapadd -v -u -d 1 -F /etc/ldap/slapd.d -l /vagrant/of.ldif
#service slapd start
ldapadd -x -w Secret007! -f /vagrant/of.ldif -D 'cn=admin,dc=openforce,dc=org'
wget http://www.opensource.apple.com/source/sudo/sudo-28/sudo/sudoers2ldif -O /root/sudoers2ldif
chmod +x /root/sudoers2ldif
