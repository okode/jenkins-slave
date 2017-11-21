# Docker Jenkins Slave Image for JDK8 builds

FROM java:6

MAINTAINER Okode <support@okode.com>

ENV TERM linux

RUN rm -rf /var/lib/apt/lists/*

ADD https://archive.apache.org/dist/maven/binaries/apache-maven-3.0.5-bin.tar.gz /opt/
RUN cd /opt && tar xf apache-maven-3.0.5-bin.tar.gz && rm apache-maven-3.0.5-bin.tar.gz && \
    ln -s /opt/apache-maven-3.0.5/bin/mvn /usr/local/bin/ && \
    ln -s /opt/apache-maven-3.0.5/bin/mvnDebug /usr/local/bin/ && \
    ln -s /opt/apache-maven-3.0.5/bin/mvnyjp /usr/local/bin/

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
