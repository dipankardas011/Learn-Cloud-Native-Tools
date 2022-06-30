FROM openjdk:17-alpine as dev

WORKDIR /work

LABEL MAINTAINER="Dipankar Das <dipankardas0115@gmail.com>"

COPY mvnw /work/mvnw
COPY .mvn /work/.mvn
COPY pom.xml /work/pom.xml

RUN ./mvnw dependency:go-offline

COPY . /work/
RUN ./mvnw install

ENTRYPOINT [ "./mvnw", "spring-boot:run" ]

EXPOSE 8080