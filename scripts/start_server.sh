#!/bin/bash

echo "eula=true" > /server/eula.txt

exec java -Xmx$MAXMEMORY -Xms$MINMEMORY -jar /scripts/jar/server.jar nogui