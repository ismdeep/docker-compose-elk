#!/usr/bin/env bash

set -e

echo-plus() {
  msg="${1:?}" && \
  EMPTY_LINES="\n\n\n\n\n" && \
  echo -e "${EMPTY_LINES}" && \
  echo "        ${msg}" && \
  echo -e "${EMPTY_LINES}"
}

# Get to workdir
cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"


# create folders
mkdir -p data/es/data/nodes/
mkdir -p data/es/logs/
mkdir -p data/es/plugins/
if [ "$(whoami)" == "root" ]; then
  chmod -R 777 data/
else
  sudo chmod -R 777 data/
fi

# start elk-es
docker-compose up -d elk-es

# wait es connection
while [ "$(curl -sSL http://127.0.0.1:9200 | jq -r '.status')" != "401" ]; do sleep 1; done

# generate password
if [ ! -f password.txt ]; then
  docker exec -it elk-es bin/elasticsearch-setup-passwords auto -b | tee password.txt
fi

# get elastic password
elastic_password="$(< password.txt grep 'PASSWORD elastic =' | sed 's+PASSWORD elastic =++' | tr -d ' \r\n\t')"

# start elk-kibana
ELASTIC_PASSWORD="${elastic_password}" envsubst < conf/kibana.yaml.tpl > conf/kibana.yaml
docker-compose up -d elk-kibana

# start elk-logstash
ELASTIC_PASSWORD="${elastic_password}" envsubst < conf/logstash.conf.tpl > conf/logstash.conf
docker-compose up -d elk-logstash

# start all
docker-compose up -d

# finished
echo-plus "OK: elk started."
