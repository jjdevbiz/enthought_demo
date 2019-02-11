#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

source ../makerc

apt-get update -qq
apt-get install -y -qq make wget curl git
apt-get remove -y -qq docker.io
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
apt-get install -y -qq apt-transport-https ca-certificates curl gnupg-agent software-properties-common
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update -qq
apt-get -y -qq install docker-ce docker-ce-cli containerd.io

# /etc/init.d/nginx-proxy
# /etc/init.d/sourcegraph-3.0

useradd -m -d /home/$APPUSER -s /bin/bash $APPUSER
usermod -aG docker $APPUSER
# git clone to $APPUSER

service docker restart

# s3cmd backups of /data (sourcegraph data), load previous backup if it doesn't exist
