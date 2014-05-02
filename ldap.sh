echo "Provisioning ldap"
cat > /tmp/slapd.debconf << EOF
slapd slapd/password1 string Secret007!
slapd slapd/password2 string Secret007!
EOF
/usr/bin/debconf-set-selections /tmp/slapd.debconf
apt-get update
apt-get install slapd ldap-utils -y
