#!/bin/bash

printLog(){
    echo -e "---------------------------------------------------------"
    echo -e "[SCRIPT] $1"
    echo -e "---------------------------------------------------------\n"
}

echo -e "eula=true" > /server/eula.txt #root permission

useradd -s /bin/bash minecraft > /dev/null 2>&1
groupadd minecraft > /dev/null 2>&1

groupmod -g $GID minecraft > /dev/null 2>&1
usermod -u $UID minecraft > /dev/null 2>&1

chown -R $UID:$GID /server > /dev/null 2>&1

JAR_TYPE=`echo -e "$TYPE" | tr '[:upper:]' '[:lower:]'`
JAR_FILE="/server/server.jar"

echo -e "---------------------------------------------------------"
echo -e "[SCRIPT] WELCOME..."
echo -e "UID: $UID"
echo -e "GID: $GID"
echo -e "JAR_TYPE: $JAR_TYPE"
echo -e "MIN_MEMORY: $MIN_MEMORY"
echo -e "MAX_MEMORY: $MAX_MEMORY"
echo -e "---------------------------------------------------------\n"

if [[ $JAR_TYPE == "forge" ]] ; then 
    if [[ ! -d "/server/libraries/net/minecraftforge/forge" ]] ; then
        printLog "No libraries, trying to download"
        
        gosu minecraft java -jar /server/forge.jar --installServer
    fi

    FORGE_VERSION=`ls /server/libraries/net/minecraftforge/forge`

    printLog "Strating $JAR_TYPE"
    
    exec gosu minecraft java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY @/server/libraries/net/minecraftforge/forge/$FORGE_VERSION/unix_args.txt "$@" nogui
elif [[ $JAR_TYPE == "file" ]] ; then
    if  [[ ! -f $JAR_FILE ]]; then
        printLog "File does not exist... exiting!"

        exit 1
    fi

    printLog "File found, starting server"

    exec gosu minecraft java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /server/server.jar nogui
elif [[ $JAR_TYPE == "link" ]] ; then
    if [[ -z $LINK ]] ; then
        printLog "No link url... exiting!"

        exit 1
    fi

    printLog "Downloading server.jar from link"

    curl -s -L "$LINK" --output /scripts/server.jar

    if [[ ! -f "/scripts/server.jar" ]] ; then
        printLog "Something went wrong with file... Exiting!"
        exit 1
    fi

    printLog "Download complete, staring server"

    exec gosu minecraft java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /scripts/server.jar nogui
else
    printLog "Wrong type: $JAR_TYPE... exiting!"

    exit 1
fi