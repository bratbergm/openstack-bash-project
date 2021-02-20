openstack server create \
--flavor t1.small \
--image 1676adb4-9657-42ed-b31f-b3907cbcd697 \
--key-name Manager \
--security-group default \
--user-data /home/ubuntu/git/DCSG2003/vms/offline/offline-data.sh \
Offline
