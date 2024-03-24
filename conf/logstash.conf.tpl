input {
	syslog {
		port => 5140
	}
}

output {
  elasticsearch {
    hosts => "elk-es:9200"
    index => "docker-%{+YYYY.MM}"
    user => "elastic"
    password => "${ELASTIC_PASSWORD}"
  }
}
