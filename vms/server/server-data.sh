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

# Database sql konfigurasjonsfil
printf ""
CREATE DATABASE bf;
CREATE USER bfuser;
GRANT ALL ON DATABASE bf TO bfuser;

USE bf;

CREATE TABLE users (
userid INT NOT NULL DEFAULT unique_rowid(),
name STRING(50) NULL,
picture STRING(300) NULL,
status STRING(10) NULL,
posts INT NULL,
comments INT NULL,
lastpostdate TIMESTAMP NULL DEFAULT now():::TIMESTAMP,
createdate TIMESTAMP NULL DEFAULT now():::TIMESTAMP,
FAMILY 'primary' (userid, posts, comments, lastpostdate),
FAMILY 'secondary' (name, picture,status, createdate)
);


CREATE TABLE posts (
postid INT NOT NULL DEFAULT unique_rowid(),
userid INT NOT NULL,
text STRING(300) NULL,
name STRING(150) NULL,
postdate TIMESTAMP NULL DEFAULT now():::TIMESTAMP,
INDEX posts_auto_index_posts_users_fk (userid ASC),
FAMILY '"primary"' (postid, userid, text, name, postdate)
);


CREATE TABLE comments (
commentid INT NOT NULL DEFAULT unique_rowid(),
userid INT NOT NULL,
postid INT NOT NULL,
text STRING(300) NULL,
postdate TIMESTAMP NULL DEFAULT now():::TIMESTAMP,
INDEX comments_userid_idx (userid ASC),
INDEX comments_postid_idx (postid ASC),
FAMILY '"primary"' (commentid, userid, postid, text, postdate)
);

CREATE table config ( key STRING(100), value STRING(500) );
insert into config ( key, value ) values ( 'migration_key', "$MIGRATION_KEY" );
" > home/ubuntu/db.sql"




# TO DO: legg til resten av config
