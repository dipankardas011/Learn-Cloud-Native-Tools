FROM jenkins/jenkins:2.176.1
# Distributed Builds plugins (1)
RUN /usr/local/bin/install-plugins.sh ssh-slaves
#Install GIT (2)
RUN /usr/local/bin/install-plugins.sh git
# Artifacts
RUN /usr/local/bin/install-plugins.sh htmlpublisher
# UI (3)
RUN /usr/local/bin/install-plugins.sh greenballs
RUN /usr/local/bin/install-plugins.sh simple-theme-plugin
# Scaling (4)
RUN /usr/local/bin/install-plugins.sh kubernetes
VOLUME /var/jenkins_home
USER jenkins