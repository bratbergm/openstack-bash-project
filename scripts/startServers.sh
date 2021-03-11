#! /bin/bash

# Starts servers that are shut down

for server in $(openstack server list | awk '{print $4}' | sed '1,3d' | sed '$d'); do
   if [[ $(openstack server show $server | grep OS-EXT-STS:power_state | awk '{print $4}')  = Shutdown ]]; then
      openstack server start $server
      echo "Starter $server"
   fi;
done
