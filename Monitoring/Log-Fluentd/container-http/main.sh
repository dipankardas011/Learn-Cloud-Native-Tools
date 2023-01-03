#!/bin/sh

apk add curl
while true
do
	echo "Sending logs to FluentD"
  curl -X POST -d 'json={"foo": "bar"}' http://fluentd:24224/http-foo.log
  curl -X POST -d 'json={"name": "dipankar"}' http://fluentd:24224/http-dipankar.log
	sleep 5
done
