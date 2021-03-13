#! /bin/bash

# Kjøres fra manager
# Når en VM skurs av, kjøres Openstack server start
# SSH kommando inn til serverne:
#	Cockroach start
#	mount


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


for server in $(openstack server list | awk '{print $4}' | sed '1,3d' | sed '$d'); do
   if [[ $(openstack server show $server | grep OS-EXT-STS:power_state | awk '{print $4}')  = Shutdown ]]; then

#Start serveren
      openstack server start $server
      echo "Starter $server"

sleep 200


# Finn IP adressen til den aktuelle serveren
serverIP=$(openstack server list \
        | grep $server \
        | awk '{print $8}' \
        | sed 's/Name//' \
        | sed 's/Networks//' \
        | sed 's/imt3003=//' \
        | sed 's/,//')

# Kjør Cockroach start via ssh (startdb.sh)
ssh $serverIP \
	sudo cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 \
	--http-addr=0.0.0.0:8080 --background \
	--join=$server1:26257,$server2:26257,$server3:26257 \
	--advertise-addr=$serverIP:26257 --max-offset=1500ms

echo "Chockroach er startet"

      
   fi;
done

