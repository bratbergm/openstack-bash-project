# CyberSec4U



Repo for gruppe 32 / CyberSec4U i DCSG2003 Robuste og skalerbare tjenester (2021 VÅR).

### **Repo Content**

- **vms**:	Directory for each type of vm, with the files
  - *name*.start.sh	- OpenStack server start script
    
  - *name*.data.sh     - user-data, startup script
- **monitoring**:                - [Se egen Readme](https://gitlab.com/morterb/DCSG2003/-/blob/master/monitoring/readmeMonit.md)
- **scripts**                          - misc scipts
- **Container Registry**    - Docker Containers

Bookface source code: https://git.cs.oslomet.no/kyrre.begnum/bookface



**Content of this page**

- Docker
  - Docker networking
  - Docker images
  - Docker and igt
- Linux Shell
  - Shell scipt
  - SCP
  - AWK
  - LOOP
  - SSH commands
- Cron
- Backup
- GIT
- MySQL

[TOC]

### **Docker**

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



#### **Docker networking**

By default: 

- All docker instances are attached to a local, private 172 network
- No port forwarding enabled 
- To specify a port to be *exposed* when running the instance 
  - -p 80  Expose port 80 on the instance. Will use a host port 49000-49900
  - -p 80:80  Expose port 80 on the instance. Local port 80. (remember only one service can use each port)



#### **Docker Images**

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
ENV DEBIAN_FRONTEND=noninteractive   # NB: hvis nyere ubuntu versjon
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
# Run, auto start at host boot
docker run --restart=unless-stopped --name=<NAVN> -P -d webserver:v1 /usr/sbin/apache2ctl -D FOREGROUND
```

Test

```bash
# Find local port
docker ps
#
wget -O - -q http://<ip:port>
```



#### **Docker and git**

- Can build images based on folders in a git repository

```bash
docker build -t "webserver:v1" <docker-git-repo>
```

```bash
# image:
# https://gitlab.com/morterb/bookface2
# Build from repository
docker build -t "webserver:v1" git@gitlab.com:morterb/bookface2.git
# Run
docker run --restart=unless-stopped --name=webserver -P -d webserver:v1 /usr/sbin/apache2ctl -D FOREGROUND
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



### **Linux shell**

#### **Shell script**

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

- Linjene kjører uavhengig av hverandre
- -x hvert output skrives ut
- Varibler
  - VAR="dette er en tekst"
  - For å bruke variabelen; $ forran
  - chmod +x  <filen>    



Forrige kommandos exitverdi ligger lagret i $?

- Exitverdi: 0 kommanmdoen gikk bra
- Annen verdi: kommandoen gikk ikke bra
- IF tester bruker exit verdier

```bash
if ls temp.txt; then echo "Alt er OK"; fi

```

- [ ] alias på test kommandoen 



#### **SCP**

```bash
# Overføre
scp <-r> file|directory destination:
# : is root dir
# Hente
scp server:fil .
```

```
# Stoppe opp, ta vare på en kommando:
ctrl k # kutter fra curser
ctrl i # limer det inn
```

#### **AWK**

```bash
# skriv ut det som er på kollone 9 på linjene som inneholder ordet ready
<kommando> | grep ready | awk '{ print $9}'
```

#### **LOOP**

```bash
# for VAR in REKKE; do ........; done
for server in $( <kommando> | grep ready | awk '{ print $9}' ); do echo "server: $server"	; done
#
# Tell opp
seq -w 10
for tall in $(seq 1 10); do echo "tall: $tall"; done
```

#### **SSH commands**

```bash
ssh <server> <kommando>
#
for server in $( <kommando> | grep ready | awk '{ print $9}' ); do echo "server: $server"	; ssh $server uptime  ; done
#
# Send meldinger til søppelbøtte
for server in $( <kommando> | grep ready | awk '{ print $9}' ); do echo "server: $server"	; ssh $server uptime  ; done 2>/dev/null
```



### **cron**

- Kjøre ting på tidspunkt

- editere /etc/crontab

- Brukere kan lage egne crontab filer

- syntax

  - ```bash
    min hr dom mon dow user command
    # * hver
    */5 hvert 5 min
    # send OK mail hver time (hvis overvåkningen også går ned)
    00 * * * * root date | mail -s OK admin
    ```

    



### **Backup**

Kort oppsummert

- Enkelt
- Viktig
- Kan bli dyrt
- Lite fokus på restore



Begreper

- Corpus_ Datamengden som skal bli tatt backup av
- Endringsrate: Endringer i corup
- Backup vindu: Når kan du ta backup
- Snapshot: Tar lokal kopi, tar backup av den, slik at corpus kan endre seg underveis
- Lokal/remote: Hvor plasserers backup
- Medium: Hvor dataen lagres



Strategier:

- Partiell
  - Stor corpus, må dele opp (eks, 7 deler og tar backup av en del hver dag)
- Inkrementell
  - Kun backup av endringene 
  - Forutsetter en full backup tidligere
- Full

Kombineres gjerne

Linux verktøy

- tar + gz
  - gzip av hel mappe
- rsync
  - synkronisere to mapper, gjerne over SSH
- spc (Flytt filer med SSH)
- cp -al
  - kopi, men lager bare ny inode(hardlink). Bruker ikke er plass før den originale filen endrer seg. -a beholder eierskap og rettigheter.



Binær-log

- MySQL funksjonalitet
- Logg av operasjoner som forandrer data
- /var/log/mysql/mysql-bin.xxxx(tall)
- mysql-bin.index holder orden
- 'mysqlbinlog' for å lese



Logfil vedlikehold

- Linux roterer log-filene eks logger hver dag, sletter en uke gammel logg
- /etc/logrotate.d/mysql-server
- Fremprovosere ny binær-log fil
  - mysqladmin flush-logs



MySQL

- 'mysqldump'
- Skriver ut all SQL kode til skjerm
  - Dette kan brukes til restore
- eks
  - mysqldu,p [opsjoner] database [tabeller]	- En DB
  - mysqlsump [opsjoner] -- databases db1 db2 db3
  - mysqldump [opsjoner] --all-databases
- Typisk backup av alt
  - myaqldump --opt --master-data=2 --flush-logs --all-databases > backup.sql
  - Filen har nå alt som trengs til å restore
  - cat backup | mysql



NB: restore fra dump havner også i bin-log

- Kan forhindres på flere måter
  - Set stop-posisjon med mysqlbinlog
  - Legg til linjen 'SET sql_log_bin=0' øverst i backup.sql
  - Flush loggene før restore: 'mysqladmin flush-logs'
- Tenk over: kan man bare kjøre restore?, må noe fjernes, hva fårorsaket problemet?



Strategi

- Kjør dump (full backup) med gjevne mellomrom (ukentlig, natt, eller ved minst aktivitet)
- Roter binør-logfilene med kortere intervaller (inkrementell backup) etter hver dump
- Hold orden på hvilke binære loggfiler som kommer etter hvilken dump
- Total gjennoppretting vil da bestå av
  - Restore fra dump
  - Restore fra påfølgende binær-logfiler (disse må ligge ett annet sted enn på database-serveren)



Fjerne uønskede kommandoer fra bin-log

- Kjør mysqlbinlog fra de aktuelle logfilene og lagre resultatet i en ny fil
  - mysqlbinlog mysql-bin.* > binlog.sql
- Editer, fjern linjer
  - nano binlog.sql
- Kjør filen på databasen
  - cat binlog.sql | mysql





**Mount volum som disk**

*Se disker*

```bash
# Se disker
sfdisk -l
# Make filesystem  (som formatere disk i Windows)
mkfs.ext4 /dev/XXX ^
# Mount disken til en mappe i filsystemet (overskriver om det ligger noe i denne mappen)
mkdir /backup
#
mount /dev/XXX /backup
# Sjekk
df -h
# un-mount
umount /backup
```





### **GIT**

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





### **MySQL**

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




