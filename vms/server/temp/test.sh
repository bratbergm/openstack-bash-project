#! /bin/bash
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


sleep 1
token=$(ssh $server1 sudo docker swarm init | sed '1,4d' | sed '2,4d')
sleep 1
echo "$token"
sleep 1
ssh $server2 $token

sleep 1

ssh $server3 $token


