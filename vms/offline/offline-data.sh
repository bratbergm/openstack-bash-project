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


# Offline webside

# HTML
printf "
<html>
<head>
    <title>CyberSec4U</title>
</head>
<body>
    <h1>Siden er nede for vedlikehold</h1>
</body>
</html>
" > /home/ubuntu/index.html

sleep 1


# Dockerfile
printf "
   FROM httpd:2.4
   COPY ./index.html /usr/local/apache2/htdocs/
" > /home/ubuntu/Dockerfile

sleep 1

# Build and run
sudo docker build -t offline:v1 /home/ubuntu/

sleep 1

sudo docker run -dit --name offline -p 8080:80 offline:v1

sleep 1


final_message: "Ferdig!!"
echo "Ferdig"
