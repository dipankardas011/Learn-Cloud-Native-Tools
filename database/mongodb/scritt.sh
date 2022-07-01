#!/bin/sh
docker pull mongo

docker run -d --name db-mongo -p 27017:27017 mongo

docker exec -it db-mongo bash

> mongo