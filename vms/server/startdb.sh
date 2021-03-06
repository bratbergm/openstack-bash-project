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


# Kjør cockroach start på hver av serverne

# Server 1
ssh $server1 \
	sudo cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 \
	--http-addr=0.0.0.0:8080 --background \
	--join=$server1:26257,$server2:26257,$server3:26257 \
	--advertise-addr=$server1:26257 --max-offset=1500ms 2>/dev/null

echo "Server1 ($server1) OK!"

# Server 2
ssh $server2 \
	sudo cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 \
	--http-addr=0.0.0.0:8080 --background \
	--join=$server1:26257,$server2:26257,$server3:26257 \
	--advertise-addr=$server2:26257 --max-offset=1500ms 2>/dev/null

echo "Server2 ($server2) OK!"

# Server 3
ssh $server3 sudo cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --join=$server1:26257,$server2:26257,$server3:26257 --advertise-addr=$server3:26257 --max-offset=1500ms 2>/dev/null
echo "Server3 ($server3) OK!"


# Initialisere databasen

ssh $server1 sudo cockroach init --insecure --host=$server1:26257



