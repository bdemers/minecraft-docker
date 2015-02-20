
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
  
# look into this 
# RUN rm -rf /var/lib/apt/lists/*

# ADD http://fyreuk.tehbanana.com/Remnant_FYREUK_HungerGamesMap.zip ${MINECRAFT_DIR}/remnant
RUN \
  apt-get install -y curl unzip && \
  curl http://fyreuk.tehbanana.com/Remnant_FYREUK_HungerGamesMap.zip -o temp.zip && \
  unzip temp.zip -d ${MINECRAFT_DIR}/remnant && \
  rm temp.zip

ADD http://dev.bukkit.org/media/files/773/95/remotebukkitplugin-4.0.0.jar ${MINECRAFT_DIR}/plugins/
ADD http://dev.bukkit.org/media/files/588/781/Multiverse-Core-2.4.jar ${MINECRAFT_DIR}/plugins/

ADD ./minecraft.sh /opt/minecraft/
ADD ./server.properties /opt/minecraft/

WORKDIR ${MINECRAFT_DIR}

EXPOSE 25565
EXPOSE 25564

ENV SERVER_USER mine_ops
ENV SERVER_PASS password

ENTRYPOINT /opt/minecraft/minecraft.sh

CMD minecraft
