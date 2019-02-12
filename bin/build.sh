#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

source ../makerc

# nginx-proxy
cd ../dockerfiles/nginx-proxy
make build-nginx # push-nginx

# sourcegraph
sourcegraph_container=sourcegraph/server:3.0.1
docker pull $sourcegraph_container
