# Docker Jenkins Slave Image for JDK6 builds

FROM okode/jenkins-slave-jdk8:latest

MAINTAINER Okode <support@okode.com>

RUN apt-get -y update && \
    echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get -y -q install oracle-java6-installer && \
    apt-get -y -q install oracle-java6-set-default

# Use JDK8 *only* for running Jenkins agent. JDK6 remains as default Java for other processes.
CMD /usr/lib/jvm/java-8-oracle/jre/bin/java -jar /jenkins/agent/slave.jar \
    -jnlpUrl ${JENKINS_JNLP_URL} \
    -secret ${JENKINS_SECRET} \
    -noCertificateCheck
