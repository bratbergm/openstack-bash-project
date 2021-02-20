#! /bin/bash

sleep 1
sudo apt-get update;

sleep 1

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common;

sleep 1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sleep 1
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable";

sleep 1

sudo apt-get update

sleep 1

sudo apt-get -y install docker-ce docker-ce-cli containerd.io

sleep 1

sudo groupadd docker 
sudo gpasswd -a $USER docker 
sudo service docker restart

sleep 1

sudo reboot

final_message: "Ferdig!!"
echo "Ferdig"

