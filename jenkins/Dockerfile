FROM docker

RUN apk add openjdk8 vim curl
ARG user=jenkins
ARG group=jenkins
ARG VERSION=3.20

RUN mkdir /home/${user}

ARG AGENT_WORKDIR=/home/${user}/agent
RUN apk add sudo

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod 777 /usr/local/bin/jenkins-slave

RUN echo 'jenkins ALL=(ALL) NOPASSWD:ALL'| EDITOR='tee -a' visudo
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}
VOLUME /home/${user}/.jenkins

VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
