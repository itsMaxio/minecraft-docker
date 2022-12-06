#!/bin/bash
echo "eula=true" > /server/eula.txt #root permission

useradd -s /bin/bash minecraft
groupadd minecraft

groupmod -g $UID minecraft
usermod -u $UID minecraft

chown -R $UID:$UID /server

exec gosu minecraft java -Xmx$MAXMEMORY -Xms$MINMEMORY -jar /scripts/jar/server.jar nogui