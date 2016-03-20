# Docker Jenkins Slave Image for JDK7 builds

FROM ubuntu:latest

MAINTAINER Okode <support@okode.com>

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV TERM linux

RUN apt-get -y update

RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get -y update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get -y -q install oracle-java7-installer && \
    apt-get -y install git

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /jenkins/agent
RUN mkdir -p /jenkins/workspace

COPY resources/slave.jar /jenkins/agent/

VOLUME /jenkins/workspace

ENV JENKINS_JNLP_URL jenkinsJnlpUrlValue
ENV JENKINS_SECRET jenkinsSecretValue

CMD java -jar /jenkins/agent/slave.jar \
    -jnlpUrl ${JENKINS_JNLP_URL} \
    -secret ${JENKINS_SECRET} \
    -noCertificateCheck
