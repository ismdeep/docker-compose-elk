elasticsearch:
  hosts:
    - http://elk-es:9200
  username: 'elastic'
  password: '${ELASTIC_PASSWORD}'

server:
  host: 0.0.0.0
  port: 5601
