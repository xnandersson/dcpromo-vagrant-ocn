Readme file

* Need to do some clean up after provisioning of dc, due to multi homed Vagrant machine.
* If we are not willing to rerun the provision we can delete the ip to NAT-if using:

  samba-tool dns delete dc openforce.org dc A 10.0.2.15

* LDAP Searches 

  ldapsearch -H ldap://dc.openforce.org -b "DC=OPENFORCE,DC=ORG" -s sub -Y GSSAPI -N "(&(objectClass=user)(sAMAccountName=nandersson))"
  ldapsearch -s sub -Y GSSAPI -N "(&(objectClass=user)(sAMAccountName=nandersson))"

