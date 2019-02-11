#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

source ../makerc

mkdir -p /etc/letsencrypt
mkdir -p /etc/nginx/conf.d
mkdir -p /etc/nginx/ssl
mkdir -p /var/log/nginx

docker run --rm -it \
	-p 80:80 \
	-p 443:443 \
	--net=host \
	-e LETSENCRYPT=$LETSENCRYPT \
	-e BACKEND_HOST=${BACKEND_HOST} \
	-e BACKEND_PORT=${BACKEND_PORT} \
	-e BACKEND_PORT_ADMIN=${BACKEND_PORT_ADMIN} \
	-e VHOSTNAME=${VHOSTNAME} \
	-v /var/log/nginx:/var/log/nginx \
	-v /etc/letsencrypt/:/etc/letsencrypt/ \
	-v /etc/nginx:/etc/nginx \
	${base_container}
