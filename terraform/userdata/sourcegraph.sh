#!/bin/bash

apt-get update
apt-get install -q -yy git make
git clone https://github.com/jjdevbiz/enthought_demo.git
cd enthought_demo
make requirements
make build
make run
