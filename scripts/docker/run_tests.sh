#!/bin/sh

sleep 10

echo 'START: run_tests.sh'

CURL_OUT="$(curl -s localhost:8080)" || exit $?

echo "START: Result of 'curl -s localhost:8080':"
echo "${CURL_OUT}"
echo "END: Result of 'curl -s localhost:8080'"
echo 'END: run_tests.sh: before exitting with final test'

curl -s localhost:8080 | grep -q Dessler
exit $?
