SHELL=bash
include makerc

all: requirements build

build-remote:
	bash -n *.sh
	bash -n bin/*.sh
	bash -n makerc
	ssh -q root@${build_remote_host} -ttt "./refresh-image-list.sh; cd /root/tradesignal; git pull; make"

build:
	./bin/build.sh

requirements:
	./bin/requirements.sh
