
FROM ubuntu:14.04

MAINTAINER bdemers@apache.org

# Update to latest
RUN \
  apt-get update && \
  apt-get -y upgrade 

# install required packages
RUN \  
  apt-get install git -y

ENV DEBIAN_FRONTEND noninteractive

# Install Java.
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get install software-properties-common -y && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/cache/oracle-jdk7-installer


ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV MINECRAFT_DIR /opt/minecraft
ENV BUILD_DIR ${MINECRAFT_DIR}/BuildTools

ADD https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar ${BUILD_DIR}/BuildTools.jar

# build / mangle the server jar
RUN \ 
  cd ${BUILD_DIR}/ && \
  ${JAVA_HOME}/bin/java -jar BuildTools.jar && \
  mv craftbukkit-*.jar spigot-*.jar ${MINECRAFT_DIR} && \
  rm -rf ${BUILD_DIR} ${HOME}/.m2

# accept the eula
RUN \
  echo "eula=true" > ${MINECRAFT_DIR}/eula.txt


WORKDIR ${MINECRAFT_DIR}

EXPOSE 25565

CMD ${JAVA_HOME}/bin/java -Xms512M -Xmx512M -XX:MaxPermSize=128M -jar spigot-*.jar
