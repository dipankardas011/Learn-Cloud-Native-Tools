#!/bin/bash
docker container run -d \
    -p 8080:8080 -p 50000:50000 \
    -v jenkins-vol:/var/jenkins_home \
    --name jenkins-local \
    jenkins/jenkins