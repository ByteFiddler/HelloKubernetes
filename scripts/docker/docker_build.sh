#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
docker build -t bytefiddler/hello-kubernetes "${DIR}"/../..
