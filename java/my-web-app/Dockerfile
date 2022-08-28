FROM docker.io/gradle:7.4.2-jdk17-alpine as build

LABEL MAINTAINER="Dipankar Das <dipsonu10@hotmail.com>"

WORKDIR /app

COPY . .

CMD ["gradle", "run"]

EXPOSE 80
