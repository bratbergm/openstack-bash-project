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
echo '* * * * * root date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"' | sudo tee -a /etc/crontab

# CockroachDB install
wget https://binaries.cockroachdb.com/cockroach-v20.2.4.linux-amd64.tgz 
tar xzf cockroach-v20.2.4.linux-amd64.tgz 
sudo cp cockroach-v20.2.4.linux-amd64/cockroach /usr/local/bin 
sudo mkdir /bfdata


# TO DO: legg til resten av config
