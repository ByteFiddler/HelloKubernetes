#!/bin/bash

set -e

docker run --name hello-kubernetes-postgres -e POSTGRES_PASSWORD=zV84bRnc8TkwgbfQ2kVZM9v154kScfZu -d -p 5432:5432 postgres
