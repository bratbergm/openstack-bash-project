#! /bin/bash

# Creates aliases for ssh 
openstack server list \
	| awk '{print $3 $4 $8}' \
	| sed 's/Name//' \
	| sed 's/Networks//' \
	| sed 's/|/alias /' \
	| sed "s/imt3003=/='ssh ubuntu@/" \
	| sed 's/,//' \
	| sed '1,3d' \
	| sed "s/$/'/" \
	| sed '$d'
