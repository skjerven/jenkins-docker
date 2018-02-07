FROM jenkins/jenkins:latest

MAINTAINER brian.skjerven@pawsey.org.au

USER root

# Instal latest Docker binaries
RUN apt-get update && \
    apt-get install -y apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
    apt-get update && \
    apt-get -y install docker-ce

# Add goss and dgoss for running Docker container tests
RUN curl -fsSL https://goss.rocks/install | sh

# Set up directories for jenkins
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins
RUN usermod -a -G docker jenkins

# Install jenkins plugins
USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
ENV JAVA_OPTS="-Xmx8192m"
