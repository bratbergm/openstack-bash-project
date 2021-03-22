#! /bin/bash

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


echo "
#!/bin/bash
cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --join=$server1:26257,$server2:26257,$server3:26257 --advertise-addr=serverX:26257 --max-offset=1500ms
while ! mount -t glusterfs 192.168.131.26:/bf_config /bf_config; do
sleep 2
done

mount -t glusterfs $server1:/bf_images /bf_images

sleep 2

systemctl start docker
"
