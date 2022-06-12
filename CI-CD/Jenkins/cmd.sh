#!/bin/bash
docker container run -d \
    -p 8080:8080 -p 50000:50000 \
    -v jenkins-vol:/var/jenkins_home \
    -v jenkins-backup:/tmp/backup \
    --name jenkins-local \
    jenkins/jenkins

# Tomcat server
docker run -d --rm -p 8081:8080 -v tomcat-vol:/usr tomcat
