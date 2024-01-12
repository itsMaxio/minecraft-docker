#!/bin/bash

printLog(){
    echo -e "\n---------------------------------------------------------"
    echo -e "[$1] $2"
    echo -e "---------------------------------------------------------"
}

echo "eula=true" > /server/eula.txt #root permission

TYPE=`echo "$TYPE" | tr '[:upper:]' '[:lower:]'`
JAR_FILE="/server/server.jar"

printLog "WELCOME" "Server informations"

echo "JAVA_VERSION:    $JAVA_VERSION"
echo "TYPE:            $TYPE"
echo "LINK:            $LINK"
echo "UID:             $UID"
echo "GID:             $GID"
echo "MIN_MEMORY:      $MIN_MEMORY"
echo "MAX_MEMORY:      $MAX_MEMORY"
# echo "MINCPU: "
# echo "MAXCPU: "
# echo "PORT: $PORT"


printLog "USER" "Creating user and changing permissions"

echo "Creating user: minecraft ($UID:$GID)"
useradd -s /bin/bash minecraft > /dev/null 2>&1
groupadd minecraft > /dev/null 2>&1

groupmod -g $GID minecraft > /dev/null 2>&1
usermod -u $UID minecraft > /dev/null 2>&1

echo "Changing permissions"
chown -R $UID:$GID /server > /dev/null 2>&1


printLog "START" "Starting as: $TYPE"

if [[ $TYPE == "forge" ]] ; then 

    if [[ ! -d "/server/libraries/net/minecraftforge/forge" ]] ; then
        echo -e "No libraries, trying to install\n"
        gosu minecraft java -jar /server/forge.jar --installServer
    fi

    FORGE_VERSION=`ls /server/libraries/net/minecraftforge/forge`
    
    echo -e "Install complete, staring server\n"
    exec gosu minecraft java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY @/server/libraries/net/minecraftforge/forge/$FORGE_VERSION/unix_args.txt "$@" nogui

elif [[ $TYPE == "file" ]] ; then

    if  [[ ! -f $JAR_FILE ]]; then
        echo "File does not exist... exiting!"
        exit 1
    fi

    echo -e "File found, starting server\n"
    exec gosu minecraft java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /server/server.jar nogui

elif [[ $TYPE == "link" ]] ; then

    if [[ -z $LINK ]] ; then
        echo "No link url... exiting!"
        exit 1
    fi

    echo "Downloading server.jar from link"
    curl -s -L "$LINK" --output /scripts/server.jar

    if [[ ! -f "/scripts/server.jar" ]] ; then
        echo "Something went wrong with file... Exiting!"
        exit 1
    fi

    echo -e "Download complete, staring server\n"
    exec gosu minecraft java -Xmx$MAX_MEMORY -Xms$MIN_MEMORY -jar /scripts/server.jar nogui

else

    echo "Wrong type: $TYPE... exiting!"
    exit 1

fi