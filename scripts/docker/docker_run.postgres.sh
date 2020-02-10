#!/bin/bash

set -e

docker network create hello-kubernetes

docker run \
	--name hello-kubernetes-postgres \
	-e POSTGRES_PASSWORD=zV84bRnc8TkwgbfQ2kVZM9v154kScfZu \
	-d \
	-p 5432:5432 \
	--net hello-kubernetes \
	postgres

# wait for postgres to be ready
while ! curl http://localhost:5432/ 2>&1 | grep '52'; do
	echo 'Waiting for postgres on localhost:5432 ...'
  sleep 1
done

trap ctrl_c INT

function ctrl_c() {
	echo "** Trapped CTRL-C for cleanup"
	docker container stop hello-kubernetes-postgres
	docker container rm hello-kubernetes-postgres hello-kubernetes-spring
	docker network rm hello-kubernetes
}

docker run \
	--name hello-kubernetes-spring \
	-e "SPRING_PROFILES_ACTIVE=postgres" \
	-p 8080:8080 \
	--net hello-kubernetes \
	-t \
	bytefiddler/hello-kubernetes
