#!/bin/bash
echo "eula=true" > /server/eula.txt #root permission

useradd -s /bin/bash minecraft
groupadd minecraft

groupmod -g $UID minecraft
usermod -u $UID minecraft

chown -R $UID:$UID /server

TYPE=`ls /scripts/jar`

echo $UID $TYPE $MINMEMORY $MAXMEMORY

if [[ $TYPE == "forge.jar" ]] ; then 

    if [[ ! -d "/server/libraries" ]] ; then
        echo "NO libraries, TRYING TO DOWNLOAD"
        gosu minecraft java -jar /scripts/jar/forge.jar --installServer
    fi

    FORGE_VERSION=`ls /server/libraries/net/minecraftforge/forge`
    
    echo "STARTING $TYPE"
    exec gosu minecraft java -Xmx$MAXMEMORY -Xms$MINMEMORY @/server/libraries/net/minecraftforge/forge/$FORGE_VERSION/unix_args.txt "$@" nogui

else

    echo "STARTING $TYPE"
    ls /scripts/jar/
    exec gosu minecraft java -Xmx$MAXMEMORY -Xms$MINMEMORY -jar /scripts/jar/server.jar nogui
    
fi

