# CyberSec4U





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



**Docker**

```bash
# Show running Docker containers
docker ps -a
# Run interactive instance
docker run -i -t #name
# 
docker start <name|id>
# - d : run in background 
#
# Check outputs: 
docker logs <id|name>
-f : continuous output (like tail -f)	
-t : add timestamps
# 
# Inspect an instance
# processes inside a instance
docker top <id|name>
# json format:
docker inspect <name|id>
docker inspect -f ‘{{.NetworkSettings.IPAddress}}’ <name|id>
#
# Run a task inside a container
docker exec <id|name> command
# get output directly: -t -i
# run command in background: -d
# 
# Stopping/deleting instance
docker stop <name|id>
docker kill <name|id>
docker rm <name|id>
# 
# Auto restart
--restart=always #option
# alternatively
--restart=on-failure:3
```



**Docker networking**

By default: 

- All docker instances are attached to a local, private 172 network
- No port forwarding enabled 
- To specify a port to be *exposed* when running the instance 
  - -p 80  Expose port 80 on the instance. Will use a host port 49000-49900
  - -p 80:80  Expose port 80 on the instance. Local port 80. (remember only one service can use each port)



**Docker Images**

*Create image with commits (not recommended) don't do it*

```bash
# Start	an instance from an existing image
docker run -t -i ubuntu:20.04 /bin/bash
# Install service(s)
apt-get install apache2  #ex
# Commit the image
docker commit -m="A webserver image" <id|name> webserver
# Check existence
docker images
```

*Using a docker file*

- Filename: Dockerfile
  - descriptive files that work as recipes for building images 
- Typically: one folder containing Dockerfile and all other files you want in the image
- Then launch the docker build



*Build example*

Create folder mkdir webserver; cd webserver

Dockerfile ex:

```dockerfile
# verison 0.1
FROM ubuntu:20.04
MAINTAINER ... ...
RUN apt-get update
RUN apt-get -y install apache2
RUN echo "Hello world" > /var/www/html/index.html
EXPOSE 80
```

Build the image, Launch the instance 

```bash
docker build -t "webserver:v1" .
# Check existence
docker images
# Run
docker run -P -d webserver:v1 /usr/sbin/apache2ctl -D FOREGROUND
```

Test

```bash
# Find local port
docker ps
#
wget -O - -q http://<ip:port>
```



*Docker and git*

- Can build images based on folders in a git repository

```bash
docker build -t "apachephp:v1" <docker-git-repo>
```



*Build features*

- CMD - Specify the command to run (can be overridden on the command line) 
- WORKDIR - Set the working directory for RUN commands
- ENV - Set environment variables during build and also when creating the instance
- USER - The user to execute the CMD
- VOLUME - Attach a folder to the instance 
- ADD - Copy a file into the image (can also be an URL, AND can automatically unpack archives (tar, zip, gzip)) 
- COPY - Like ADD but with fewer features 
- ONBUILD - Triggers that are to be executed during build
- ENTRYPOINT - Overrides the default shell /bin/sh with another binary
  - By default commands are executed via shell (bin/sh)
  - Can have an instance execute a process directly
    - Specify this process with ENTRYPOINT 
  - Ex: ENTRYPOINT [/user/sbin/apache2] This instance can only do apache, unless you do EXEC later
  - Arguments passed to the instance will now be arguments to the apache service



*Volume features*

- Volumes: Shared folders between host an done or more container instances 
- VOLUME in Dockerfile / -v option on run 
- Can be shared between instances and reused across images
- Find location of the folder: docker inspect command

Share a specific folder

```bash
docker run -t -i -v /opt/localtata:/opt/data ....
# read-only
-v /opt/localdata:/opt/data:ro
# also with files
-v /opt/mydatafile:/opt/data 
# This is not possible for Dockerfiles (it's not portable)
```

*Volume containers*

- Create an instance with one or more volumes and share it between other instances
  - Create it without starting and using it

```bash
docker create -v /dbdata --name dbdata training/postgres
```

- Then create other instances with the same volume

  ```bash
  docker run -d --volumes-from dbdata --name db1 training/postgres
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




