# Docker Jenkins Slave Image for Android (JDK8) builds

FROM okode/jenkins-slave-jdk8:latest

MAINTAINER Okode <support@okode.com>

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq curl libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
    apt-get clean

ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

RUN echo y | android update sdk --no-ui --all
