**Backup**

Kort oppsummert

- Enkelt
- Viktig
- Kan bli dyrt
- Lite fokus på restore



Begreper

- Corpus_ Datamengden som skal bli tatt bacjup av
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



















































