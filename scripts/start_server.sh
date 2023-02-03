#!/bin/bash
echo "eula=true" > /server/eula.txt #root permission

useradd -s /bin/bash minecraft
groupadd minecraft

groupmod -g $GID minecraft
usermod -u $UID minecraft

chown -R $UID:$GID /server

JAR_TYPE=`echo "$TYPE" | tr '[:upper:]' '[:lower:]'`
JAR_FILE="/server/server.jar"

echo "UID: $UID GID: $GID JAR_TYPE: $JAR_TYPE MINMEMORY: $MINMEMORY MAXMEMORY: $MAXMEMORY"

if [[ $JAR_TYPE == "forge" ]] ; then 

    if [[ ! -d "/server/libraries/net/minecraftforge/forge" ]] ; then
        echo "NO libraries, TRYING TO DOWNLOAD"
        gosu minecraft java -jar /scripts/jar/forge.jar --installServer
    fi

    FORGE_VERSION=`ls /server/libraries/net/minecraftforge/forge`
    echo "STARTING $JAR_TYPE"
    exec gosu minecraft java -Xmx$MAXMEMORY -Xms$MINMEMORY @/server/libraries/net/minecraftforge/forge/$FORGE_VERSION/unix_args.txt "$@" nogui

elif [[ $JAR_TYPE == "custom" ]] ; then

    if  [[ ! -f $JAR_FILE ]]; then
        echo "FILE DOES NOT EXIST, EXITING"
        exit 1
    fi

    exec gosu minecraft java -Xmx$MAXMEMORY -Xms$MINMEMORY -jar /server/server.jar nogui

else

    echo "STARTING $JAR_TYPE"
    exec gosu minecraft java -Xmx$MAXMEMORY -Xms$MINMEMORY -jar /scripts/jar/server.jar nogui
    
fi

