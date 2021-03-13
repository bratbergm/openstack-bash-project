#! /bin/bash

# Starter servere som er av

var=1


while [ $var -eq 1 ]
do

for server in $(openstack server list | awk '{print $4}' | sed '1,3d' | sed '$d'); do
   if [[ $(openstack server show $server | grep OS-EXT-STS:power_state | awk '{print $4}')  = Shutdown ]]; then

#Start serveren
      openstack server start $server

   fi;
done
sleep 1800
done
