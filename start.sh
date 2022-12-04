#!/bin/bash

docker compose down --rmi all --remove-orphans -t 20

docker compose up -d --build