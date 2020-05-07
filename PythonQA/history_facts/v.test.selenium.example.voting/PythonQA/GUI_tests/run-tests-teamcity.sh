#!/usr/bin/env bash

set -e

pushd ${BASH_SOURCE%/*}

py -3 behave-parallel.py -p 3 -D agent --tags @$1

popd