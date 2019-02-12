SHELL=bash
include ../../makerc

all: build-nginx push-nginx

build-nginx:
	docker build -t ${base_container} -f ${base_dockerfile} .

push-nginx:
	docker push ${base_container}

# run-nginx:
# 	./bin/run.sh
