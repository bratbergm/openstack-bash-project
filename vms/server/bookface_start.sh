#!/bin/bash

cockroach start --insecure --store=/bfdata --listen-addr=0.0.0.0:26257 --http-addr=0.0.0.0:8080 --background --join=192.168.131.225:26257,192.168.129.164:26257,192.168.129.166:26257 --advertise-addr=192.168.129.166:26257 --max-offset=1500ms

mount -t glusterfs 192.168.131.225:/bf_config /bf_config

sleep 2

mount -t glusterfs 192.168.131.225:/bf_images /bf_images

sleep 2

systemctl start docker

