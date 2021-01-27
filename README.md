# Repo for DCSG2003 Robuste og skalerbare tjenester





**OpenStack**

```bash
# List parameters
openstack flavor list
openstack image list
#
# Create server
openstack server create --flavor FLAVOR_ID --image IMAGE_ID --key-name KEY_NAME \
  --user-data USER_DATA_FILE --security-group SEC_GROUP_NAME --property KEY=VALUE \
  INSTANCE_NAME
  
# Check if the instance is online
openstack server list # / nova list

```

**MySQL**

```bash
# Install
apt-get update
#
apt-get install mysql-server
# Velg root pw. Husk på
#
# Koble til DB
mysql -u root -p mysql
# Koble til DB som er på en annen server:
mysql -h server -u root -p mysql
# Etter installasjon:
# Sjekk versjon
mysqladmin -u root -p version
# Vis config
mysqladmin -u root -p variables
# Vis innhold i DB
mysqladmin -p
mysqladmin -p mysql
#
# Start / Stop (Hvis installert fra pakker)
service mysql start|stop
# Status
service mysql status
#
# Brukeradministrasjon
# Oprette bruker
grant <rettigheter> on <database> to 'bruker'@'server' [ identified by 'passord' ]; #(frivillig med pw)
# Eks: en bruker som kun kan se bruk:
grant usage on *.* to 'admin'@'localhost'
# Eks: bruker med flere rettigheter
grant SELECT,UPDATE,INSERT,CREATE,DROP,DELETE on shop.* to 'shuser'@'%' identified by 'shuserpassord';
#
# List brukere
SELECT * FROM mysql.user/G  # Åpenrom før /  ??
# Sette nytt passord
set password for 'root'@'localhost' = PASSWORD('passord');
# Fjern bruker
DELETE FROM mysql.user WHERE User = 'brukernavn';
# Etter hver forandring:
flush privileges;
#
# Konfigurasjon: (Hovedkonfig. fil: my.cnf)
/etc/mysql/
# Databasene ligger under
/var/lib/mysql
# mysqld -> bind-address = 0.0.0.0 eller subnettet vi bruker
#        -> max_connections = ..
#
#
# BookFace
# initialisering 
http://webserver/createdb.php
# Sjekk forside
http://webserver




# Nettverksstatus; ikke DNS (vis IP), lyttende porter, TCP, prosessnavn (hvis man er root)
netstat -anltp
```







**Shell Script**

```bash
#! /bin/bash
function <Name> {
	
}
<Name>

# .sh
# chmod +X
# Alias: 
# Append <alias name='Command'> to ~/.bashrc
# Source ~/.bashrc
```



**Git; remove files**

*From both Git repo and filesystem*

```bash
git rm file.txt
git commit -m "removed file.."
git push
```

*From git repo only*

```bash
git rm --cached file.txt
git commit -m "removed file.."
git push
```

