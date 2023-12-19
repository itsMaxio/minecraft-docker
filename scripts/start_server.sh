#!/bin/bash
echo "eula=true" > /server/eula.txt #root permission

useradd -s /bin/bash minecraft
groupadd minecraft

groupmod -g $GID minecraft
usermod -u $UID minecraft

chown -R $UID:$GID /server

JAR_TYPE=`echo "$TYPE" | tr '[:upper:]' '[:lower:]'`
JAR_FILE="/server/server.jar"

echo "WELCOME..."
echo "UID: $UID GID: $GID JAR_TYPE: $JAR_TYPE MIN_MEMORY: $MIN_MEMORY MAX_MEMORY: $MAX_MEMORY"

if [[ $JAR_TYPE == "forge" ]] ; then 

    if [[ ! -d "/server/libraries/net/minecraftforge/forge" ]] ; then
        echo "No libraries, trying to download."
        gosu minecraft java -jar /server/forge.jar --installServer
    fi

    FORGE_VERSION=`ls /server/libraries/net/minecraftforge/forge`
    echo "Strating $JAR_TYPE"
    exec gosu minecraft java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY @/server/libraries/net/minecraftforge/forge/$FORGE_VERSION/unix_args.txt "$@" nogui

elif [[ $JAR_TYPE == "file" ]] ; then

    if  [[ ! -f $JAR_FILE ]]; then
        echo "File does not exist... exiting!"
        exit 1
    fi

    echo "File found, starting server."
    exec gosu minecraft java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /server/server.jar nogui

elif [[ $JAR_TYPE == "link" ]] ; then
    
    if [[ -z $LINK ]] ; then
        echo "No link url... exiting!"
        exit 1
    fi

    echo "Downloading server.jar from link."
    curl -s -L "$LINK" --output /scripts/server.jar

    if [[ ! -f "/scripts/server.jar" ]] ; then
        echo "Something went wrong with file... Exiting!"
        exit 1
    fi

    echo "Download complete, staring server."
    exec gosu minecraft java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /scripts/server.jar nogui

else

    echo "Wrong type: $JAR_TYPE... exiting!"
    exit 1

fi

