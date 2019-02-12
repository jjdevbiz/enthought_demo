#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

source ../makerc

sudo apt-get update -qq
sudo apt-get install -y -qq make wget curl git
sudo apt-get remove -y -qq docker.io
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo apt-get install -y -qq apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update -qq
sudo apt-get -y -qq install docker-ce docker-ce-cli containerd.io

sudo mkdir -p /etc/letsencrypt
sudo mkdir -p /etc/nginx/conf.d
sudo mkdir -p /etc/nginx/ssl
sudo mkdir -p /var/log/nginx

sudo mkdir -p $sourcegraph_config
sudo mkdir -p $sourcegraph_data

sudo useradd -m -d /home/$APPUSER -s /bin/bash $APPUSER
sudo usermod -aG docker $APPUSER
sudo usermod -aG docker ubuntu
# su -c "git clone $git_demo" $APPUSER

sudo service docker restart

# s3cmd backups of /data (sourcegraph data), load previous backup if it doesn't exist
