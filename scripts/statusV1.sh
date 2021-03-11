#! /bin/bash

# for hver server (openstack server list grep navn)
# server navn: openstack server list | awk '{print $4}' | sed '1,3d' | sed '$d'
# if awk nr = SHUTDOWN: openstack server navn start
# else navn er oppe


for server in $(openstack server list | awk '{print $4}' | sed '1,3d' | sed '$d'); do
   printf "$server"
   if [[ $(openstack server show $server | grep OS-EXT-STS:power_state | awk '{print $4}')  = Running ]]; then
      printf " - Oppe\n"
   else
      printf " - Nede\n"
   fi;
done


