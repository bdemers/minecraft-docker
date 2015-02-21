#!/bin/sh

# unpack worlds if this is the first time they have been installed
for world in $( find ${DEFAULT_WORLDS_DIR} -name "*.zip" ); do
    world_name=$(basename "${world%.*}")
	if [ ! -d ${MINECRAFT_DIR}/${world_name} ]; then
		unzip ${world} -d ${MINECRAFT_DIR}/${world_name}
	fi	
done


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