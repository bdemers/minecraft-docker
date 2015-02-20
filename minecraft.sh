#!/bin/sh

mkdir -p ${MINECRAFT_DIR}/plugins/RemoteBukkit/

cat > ${MINECRAFT_DIR}/plugins/RemoteBukkit/config.yml<<EOF
port: 25564
verbose: true
logsize: 500
users:
- user: ${SERVER_USER}
  pass: ${SERVER_PASS}
EOF

exec ${JAVA_HOME}/bin/java -Xms512M -Xmx512M -XX:MaxPermSize=128M -jar spigot-*.jar