#!/bin/sh

curl -s localhost:8080 | grep -q Dessler
exit $?
