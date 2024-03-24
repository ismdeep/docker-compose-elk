#!/usr/bin/env bash

set -e

# Get to workdir
cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"

# docker-compose down
docker-compose down

# finished
echo "OK: elk has been stopped."
