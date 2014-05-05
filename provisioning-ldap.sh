echo "Provisioning ldap"
echo "ldap" > /etc/hostname
/bin/hostname -b ldap
cat > /etc/hosts << EOF
127.0.0.1	localhost
127.0.1.1	ldap
EOF
cat > /tmp/slapd.debconf << EOF
slapd slapd/password1 string Secret007!
slapd slapd/password2 string Secret007!
EOF
/usr/bin/debconf-set-selections /tmp/slapd.debconf
apt-get update
apt-get install slapd ldap-utils -y
