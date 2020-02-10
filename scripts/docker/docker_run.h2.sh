#!/bin/bash

set -e

trap ctrl_c INT

function ctrl_c() {
	echo "** Trapped CTRL-C for cleanup"
	docker container rm hello-kubernetes-spring
}

docker run \
	--name hello-kubernetes-spring \
	-e "SPRING_PROFILES_ACTIVE=h2" \
	-p 8080:8080 \
	-t \
	bytefiddler/hello-kubernetes
