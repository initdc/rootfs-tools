#!/bin/sh

set -e

main() {
    apt-get update
    apt-get install -y
}

main "$@"
