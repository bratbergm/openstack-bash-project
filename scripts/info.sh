#! /bin/bash

# Get names and IP of all VMs
# Get names and portnumber of docker cotainers

printf "Server	 -   IP"
openstack server list \
	| awk '{print $4 $8}' \
	| sed 's/Name//'  \
	| sed 's/Networks//' \
	| sed 's/imt3003=/ /' \
	| sed 's/,//'


for server in $(openstack server list \
	| awk '{print $4 $8}' \
	| sed 's/Name//' \
	| sed 's/Networks//' \
	| sed 's/imt3003=/ /' \
	| sed 's/,//' | sed 's/192.168.132.70//' \
	| awk '{print $2}'); \
		 do printf "\nDocker-Porter på VM - $server:"; ssh $server sudo docker ps | awk '{print $12 $11}'; done



