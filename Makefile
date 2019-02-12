SHELL=bash
include makerc

all: requirements build

requirements:
	./bin/requirements.sh

build:
	./bin/build.sh

run:
	./bin/run.sh
