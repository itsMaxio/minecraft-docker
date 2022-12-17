#!/bin/bash
echo "eula=true" > /server/eula.txt #root permission

useradd -s /bin/bash minecraft
groupadd minecraft

groupmod -g $GID minecraft
usermod -u $UID minecraft

chown -R $UID:$GID /server

JAR_TYPE=`ls /scripts/jar`

echo UID: $UID GID: $GID JAR_TYPE: $JAR_TYPE MINMEMORY: $MINMEMORY MAXMEMORY: $MAXMEMORY

if [[ $JAR_TYPE == "forge.jar" ]] ; then 

    if [[ ! -d "/server/libraries/net/minecraftforge/forge" ]] ; then
        echo "NO libraries, TRYING TO DOWNLOAD"
        gosu minecraft java -jar /scripts/jar/forge.jar --installServer
    fi

    FORGE_VERSION=`ls /server/libraries/net/minecraftforge/forge`
    
    echo "STARTING $JAR_TYPE"
    exec gosu minecraft java -Xmx$MAXMEMORY -Xms$MINMEMORY @/server/libraries/net/minecraftforge/forge/$FORGE_VERSION/unix_args.txt "$@" nogui

else

    echo "STARTING $JAR_TYPE"
    ls /scripts/jar/
    exec gosu minecraft java -Xmx$MAXMEMORY -Xms$MINMEMORY -jar /scripts/jar/server.jar nogui
    
fi

