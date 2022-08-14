#!/bin/sh
while true
do
	echo "Writing log to a file"
  echo $(echo '{"app":"Hello from app", "age": "5s", "info": {"host": "')$(hostname)$(echo "\"}}") >> /app/demo-log.log
	sleep 5
done