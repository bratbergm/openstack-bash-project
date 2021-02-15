#! /bin/bash


sudo apt-get update;

sleep 5;

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common;

sleep 5;

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -;

sleep 5;

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable";

sleep 5;

sudo apt-get update; 

sleep 5;

sudo apt-get -y install docker-ce docker-ce-cli containerd.io;

