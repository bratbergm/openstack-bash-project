#!/bin/bash

echo "Bookface auto start script"

sudo cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --joi
while ! mount -t glusterfs 192.168.131.26:/bf_config /bf_config; do
sleep 2
done

mount -t glusterfs 192.168.131.26:/bf_images /bf_images

sleep 2

systemctl start docker