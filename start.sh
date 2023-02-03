#!/bin/bash

source ./.env

docker compose down --rmi all --remove-orphans -t 30

docker compose up -d --build

docker logs --follow $SERVER_NAME