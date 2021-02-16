#!/bin/bash

sudo apt update

sudo apt install docker.io -y



sudo docker run hello-world

sudo groupadd docker

sudo systemctl start docker

sudo systemctl enable docker

