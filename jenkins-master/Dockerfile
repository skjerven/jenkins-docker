FROM jenkins/jenkins:latest

MAINTAINER Brian Skjerven (brian.skjerven@pawsey.org.au)

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
    apt-get -y install docker-ce && \
    rm -rf /var/lib/apt/lists/*

# Add goss and dgoss for running Docker container tests
#RUN curl -fsSL https://goss.rocks/install | sh

# Set up directories for Jenkins
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN usermod -a -G docker jenkins

USER jenkins

# Use Jenkins script to install recommended plugsin (and some extra ones)
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

# Set Java options
#   - increase JVM memory
#   - turn off Jenkins setup wizard (we've already installed plugins above)
# -Djenkins.install.runSetupWizard=false
ENV JAVA_OPTS="-Xmx8192m"

# Set Jenkins options
#   - set max number of handler threads
#   - specify log file
ENV JENKINS_OPTS="--handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war"
