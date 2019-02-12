#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

source ../makerc

# nginx-proxy
mkdir -p /etc/letsencrypt
mkdir -p /etc/nginx/conf.d
mkdir -p /etc/nginx/ssl
mkdir -p /var/log/nginx

docker run --restart -dit \
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

# sourcegraph
mkdir -p $sourcegraph_config
mkdir -p $sourcegraph_data
docker run --restart -dit \
	-p 127.0.0.1:7080:7080 \
	-p 127.0.0.1:2633:2633 \
	--net=host \
	-v ${sourcegraph_config}:/etc/sourcegraph \
	-v ${sourcegraph_data}:/var/opt/sourcegraph \
	${sourcegraph_container}
