#!/usr/bin/env bash
set -euxo pipefail

echo "Running $@ in a loop until it fails"

while [ $? -eq 0 ]
do
    echo "Running $@"
    "$@"
done
echo "FAILED"
