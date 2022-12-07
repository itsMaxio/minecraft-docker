#!/bin/bash

TYPE=`echo "$TYPE" | tr '[:upper:]' '[:lower:]'`

if [[ ! -z $LINK ]] ; then

    if [[ $TYPE == "forge" ]] ; then

        echo "DOWNLOADING forge.jar FROM LINK"

        mkdir ./jar
        curl -s -L "$LINK" --output ./jar/forge.jar

        if [[ ! -f "./jar/forge.jar" ]] ; then
            echo "SOMETHING WENT WRONG WITH FILE"
            exit 1
        fi

        echo "DONE"
        exit 0

    else

        echo "DOWNLOADING server.jar FROM LINK"

        mkdir ./jar
        curl -s -L "$LINK" --output ./jar/server.jar

        if [[ ! -f "./jar/server.jar" ]] ; then
            echo "SOMETHING WENT WRONG WITH FILE"
            exit 1

    fi

    echo "DONE"
    exit 0
    fi

fi

if [[ $TYPE == "vanilla" ]] ; then 

    VANILLA_VERSION_URL=`curl -s 'GET' "https://launchermeta.mojang.com/mc/game/version_manifest.json" -H 'accept: application/json' | jq -r '."versions"[] | select(.id=="'$VERSION'")'.url`

    if [[ -z $VANILLA_VERSION_URL ]] ; then

        echo "VERSION NOT FOUND"
        exit 1

    fi

    VANILLA_DOWNLOAD_URL=` curl -s 'GET' "$VANILLA_VERSION_URL" -H 'accept: application/json' | jq -r ."downloads"."server"."url"`

    echo "DOWNLOADING $TYPE $VERSION server.jar"

    mkdir ./jar
    curl -s -L "$VANILLA_DOWNLOAD_URL" --output ./jar/server.jar

    if [[ ! -f "./jar/server.jar" ]] ; then
        echo "SOMETHING WENT WRONG WITH FILE"
        exit 1
    fi

    echo "DONE"
    exit 0

elif [[ $TYPE == "papermc" ]] ; then

    IF_EXISTS=`curl -s 'GET' "https://api.papermc.io/v2/projects/paper/versions/$VERSION" -H 'accept: application/json' | jq -r ."error"`

    if [[ $IF_EXISTS != "null" ]] ; then

        echo "VERSION NOT FOUND"
        exit 1

    fi

    PAPER_LAST_VERSION=`curl -s 'GET' "https://api.papermc.io/v2/projects/paper/versions/$VERSION" -H 'accept: application/json' | jq -r '.builds | max'`

    PAPER_DOWNLOAD_URL="https://api.papermc.io/v2/projects/paper/versions/$VERSION/builds/$PAPER_LAST_VERSION/downloads/paper-$VERSION-$PAPER_LAST_VERSION.jar"

    echo "DOWNLOADING $TYPE $VERSION server.jar"

    mkdir ./jar
    curl -s -L "$PAPER_DOWNLOAD_URL" --output ./jar/server.jar

    if [[ ! -f "./jar/server.jar" ]] ; then
        echo "SOMETHING WENT WRONG WITH FILE"
        exit 1
    fi

    echo "DONE"
    exit 0

fi