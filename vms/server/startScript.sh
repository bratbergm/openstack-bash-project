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
cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --join=$server1:26257,$server2:26257,$server3:26257 --advertise-addr=$server1:26257 --max-offset=1500ms
while ! mount -t glusterfs $server1:/bf_config /bf_config; do
sleep 2
done

mount -t glusterfs $server1:/bf_images /bf_images

sleep 2

systemctl start docker
" > bookface_start.sh

sleep 1

sudo chmod 755 bookface_start.sh

scp -p /home/ubuntu/git/DCSG2003/vms/server/bookface_start.sh $server1:
sleep 1
ssh $server1 sudo mv bookface_start.sh /root
sleep 1

echo "
#!/bin/bash
cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --join=$server1:26257,$server2:26257,$server3:26257 --advertise-addr=$server2:26257 --max-offset=1500ms
while ! mount -t glusterfs $server1:/bf_config /bf_config; do
sleep 2
done

mount -t glusterfs $server1:/bf_images /bf_images

sleep 2

systemctl start docker
" > bookface_start.sh


sleep 1
scp -p /home/ubuntu/git/DCSG2003/vms/server/bookface_start.sh $server2:
sleep 1
ssh $server2 sudo mv bookface_start.sh /root
sleep 1

echo "
#!/bin/bash
cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --join=$server1:26257,$server2:26257,$server3:26257 --advertise-addr=$server3:26257 --max-offset=1500ms
while ! mount -t glusterfs $server1:/bf_config /bf_config; do
sleep 2
done

mount -t glusterfs $server1:/bf_images /bf_images

sleep 2

systemctl start docker
" > bookface_start.sh

sleep 1
scp -p /home/ubuntu/git/DCSG2003/vms/server/bookface_start.sh $server3:
sleep 1
ssh $server3 sudo mv bookface_start.sh /root


sleep 1



scp /home/ubuntu/git/DCSG2003/vms/server/bookface.service $server1:
sleep 1
ssh $server1 sudo mv bookface.service /etc/systemd/system
sleep 1
scp /home/ubuntu/git/DCSG2003/vms/server/bookface.service $server2:
sleep 1
ssh $server2 sudo mv bookface.service /etc/systemd/system
sleep 1
scp /home/ubuntu/git/DCSG2003/vms/server/bookface.service $server3:
sleep 1
ssh $server3 sudo mv bookface.service /etc/systemd/system

sleep 1

ssh $server1 sudo systemctl enable bookface
sleep 1
ssh $server2 sudo systemctl enable bookface
sleep 1
ssh $server3 sudo systemctl enable bookface

