#! /bin/bash




Offline=$(openstack server list | grep 'Offline' | awk '{print $4}')

if 
