#!/bin/sh
while true
do
  echo "Write logs to file"
  echo '{"name": "file-demo", "author": "DD"}' >> /app/file-demo.log
  sleep 5
done

