#! /bin/bash

# Legg server IPene i variabler
# For hver server (1,2,3) 
	# lag cockroach start kommando med IPene fra variblene. På riktig sted
	# Det blir 3 forskjellig cockroach start kommandoer
	# Kjør fra Manager med ssh <server> <kommando>


# IP adresse til serverne:
server1=$(openstack server list \
	| grep server1 \
	| awk '{print $8}' \
	| sed 's/Name//' \
	| sed 's/Networks//' \
	| sed 's/imt3003=//' \
	| sed 's/,//')

server2=$(openstack server list \
        | grep server2 \
        | awk '{print $8}' \
        | sed 's/Name//' \
        | sed 's/Networks//' \
        | sed 's/imt3003=//' \
        | sed 's/,//')

server3=$(openstack server list \
        | grep server3 \
        | awk '{print $8}' \
        | sed 's/Name//' \
        | sed 's/Networks//' \
        | sed 's/imt3003=//' \
        | sed 's/,//')

# Sjekk om serverene er oppe
ssh $server1 date
ssh $server2 date
ssh $server3 date


# Skru av Docker, pga. først må mounte
sleep 1
ssh $server1 sudo systemctl disable docker
sleep 1
ssh $server1 sudo systemctl disable docker.service
sleep 1
ssh $server1 sudo systemctl disable docker.socket
sleep 1

ssh $server2 sudo systemctl disable docker
sleep 1
ssh $server2 sudo systemctl disable docker.service
sleep 1
ssh $server2 sudo systemctl disable docker.socket

sleep 1
ssh $server3 sudo systemctl disable docker
sleep 1
ssh $server3 sudo systemctl disable docker.service
sleep 1
ssh $server3 sudo systemctl disable docker.socket

sleep 1


# Kjør cockroach start på hver av serverne

# Server 1
ssh $server1 \
	sudo cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 \
	--http-addr=0.0.0.0:8080 --background \
	--join=$server1:26257,$server2:26257,$server3:26257 \
	--advertise-addr=$server1:26257 --max-offset=1500ms

sleep 1

# Server 2
ssh $server2 \
	sudo cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 \
	--http-addr=0.0.0.0:8080 --background \
	--join=$server1:26257,$server2:26257,$server3:26257 \
	--advertise-addr=$server2:26257 --max-offset=1500ms

sleep 1

# Server 3
ssh $server3 \
	sudo cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 \
	--http-addr=0.0.0.0:8080 --background \
	--join=$server1:26257,$server2:26257,$server3:26257 \
	--advertise-addr=$server3:26257 --max-offset=1500ms


sleep 1

# Initialisere databasen
ssh $server1 sudo cockroach init --insecure --host=$server1:26257

sleep 1


scp /home/ubuntu/git/DCSG2003/vms/server/db.sql ubuntu@$server1:

sleep 1



# Opprett datbasen til Bookface
# db.sql legges til i serverne ved oppstart

ssh $server1 cockroach sql --insecure --database=bf < db.sql

sleep 1

ssh $server1 sudo gluster peer probe $server2
ssh $server1 sudo gluster peer probe $server3

sleep 1

ssh $server1 sudo gluster volume create bf_images replica 3 $server1:/bf_brick $server2:/bf_brick $server3:/bf_brick force
ssh $server1 sudo gluster volume start bf_images
ssh $server1 sudo gluster volume create bf_config replica 3 $server1:/config_brick $server2:/config_brick $server3:/config_brick force
ssh $server1 sudo gluster volume start bf_config

sleep 1


ssh $server1 sudo mount -t glusterfs $server1:bf_config /bf_config
ssh $server1 sudo mount -t glusterfs $server1:bf_images /bf_images

sleep 1

ssh $server2 sudo mount -t glusterfs $server1:bf_config /bf_config
ssh $server2 sudo mount -t glusterfs $server1:bf_images /bf_images

sleep 1

ssh $server3 sudo mount -t glusterfs $server1:bf_config /bf_config
ssh $server3 sudo mount -t glusterfs $server1:bf_images /bf_images

sleep 1

#Overføring av autostart scripts til server1-3

echo "#!/bin/bash

cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --join=$server1:26257,$server2:26257,$server3:26257 --advertise-addr=$server1:26257 --max-offset=1500ms

mount -t glusterfs $server1:/bf_config /bf_config

sleep 2


mount -t glusterfs $server1:/bf_images /bf_images

sleep 2

systemctl start docker
" > bookface_start.sh


sleep 1

sudo chmod 755 bookface_start.sh

scp -p /home/ubuntu/git/DCSG2003/vms/server/bookface_start.sh $server1:
sleep 1
ssh $server1 sudo mv bookface_start.sh /root
sleep 1
ssh $server1 sudo chown root:root /root/bookface_start.sh
sleep 1

echo "#!/bin/bash

cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --join=$server1:26257,$server2:26257,$server3:26257 --advertise-addr=$server2:26257 --max-offset=1500ms

mount -t glusterfs $server1:/bf_config /bf_config

sleep 2

mount -t glusterfs $server1:/bf_images /bf_images

sleep 2

systemctl start docker
" > bookface_start.sh


sleep 1
scp -p /home/ubuntu/git/DCSG2003/vms/server/bookface_start.sh $server2:
sleep 1
ssh $server2 sudo mv bookface_start.sh /root
sleep 1
ssh $server2 sudo chown root:root /root/bookface_start.sh
sleep 1

echo "#!/bin/bash

cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --join=$server1:26257,$server2:26257,$server3:26257 --advertise-addr=$server3:26257 --max-offset=1500ms

mount -t glusterfs $server1:/bf_config /bf_config

sleep 2

mount -t glusterfs $server1:/bf_images /bf_images

sleep 2

systemctl start docker
" > bookface_start.sh

sleep 1
scp -p /home/ubuntu/git/DCSG2003/vms/server/bookface_start.sh $server3:
sleep 1
ssh $server3 sudo mv bookface_start.sh /root
sleep 1
ssh $server3 sudo chown root:root /root/bookface_start.sh


sleep 1

scp /home/ubuntu/git/DCSG2003/vms/server/bookface.service $server1:
sleep 1
ssh $server1 sudo mv bookface.service /etc/systemd/system
sleep 1
scp /home/ubuntu/git/DCSG2003/vms/server/bookface.service $server2:
sleep 1
ssh $server2 sudo mv bookface.service /etc/systemd/system
sleep 1
scp /home/ubuntu/git/DCSG2003/vms/server/bookface.service $server3:
sleep 1
ssh $server3 sudo mv bookface.service /etc/systemd/system

sleep 1

ssh $server1 sudo systemctl enable bookface
sleep 1
ssh $server2 sudo systemctl enable bookface
sleep 1
ssh $server3 sudo systemctl enable bookface

sleep 1

ssh $server1 sudo docker swarm init

sleep 1

token=$(ssh $server1 sudo docker swarm join-token worker | sed '1d' | sed '1d' | sed '$d')

sleep 1

ssh $server2 sudo $token

sleep 1

ssh $server3 sudo $token

sleep 1

ssh $server1 git clone https://git.cs.oslomet.no/kyrre.begnum/bookface.git

sleep 1

echo "
global
    log         127.0.0.1 local2

    pidfile     /var/run/haproxy.pid
    maxconn     4000

defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

listen stats
    bind *:1936
    stats enable
    stats uri /
    stats hide-version
    stats auth someuser:password


frontend  db
    bind *:26257
    mode tcp
    default_backend databases

backend databases
    mode tcp
    balance     roundrobin
    server   server1 $server1:26257
    server   server2 $server2:26257
    server   server3 $server3:26257
" > haproxy.cfg

sleep 1

scp /home/ubuntu/git/DCSG2003/vms/server/haproxy.cfg $server1:

sleep 1

ssh $server1 sudo mv haproxy.cfg bookface/

sleep 1

ssh $server1 "cd bookface/ && sudo docker stack deploy -c docker-compose.yml bf"


