#! /bin/bash

# Docker install
sudo apt-get update;

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common;

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable";

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io



# Time fix



# CockroachDB install
wget https://binaries.cockroachdb.com/cockroach-v20.2.4.linux-amd64.tgz 
tar xzf cockroach-v20.2.4.linux-amd64.tgz 
sudo cp cockroach-v20.2.4.linux-amd64/cockroach /usr/local/bin 
sudo mkdir /bfdata

# GlusterFS install
sudo apt-get -y install glusterfs-server glusterfs-client
sudo systemctl enable glusterd
sudo systemctl start glusterd

sudo mkdir /bf_brick
sudo mkdir /config_brick
sudo mkdir /bf_images
sudo mkdir /bf_config





