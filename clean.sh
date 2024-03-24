#!/usr/bin/env bash

set -e

# Get to workdir
cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"

# docker-compose down
docker-compose down

# remove files
if [ "$(whoami)" == "root" ]; then
  rm -rf data/ password.txt
else
  sudo rm -rf data/ password.txt
fi

# finished
echo "OK: ELK services and storage have been cleaned up."
