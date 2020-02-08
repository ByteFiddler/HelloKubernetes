#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

mkdir -p build/dependency
cd build/dependency
jar -xf ../libs/*.jar
cd ../..

docker build \
	--build-arg DEPENDENCY=build/dependency \
	-t bytefiddler/hello-kubernetes .
