#!/bin/bash

docker logs mcserver

echo "DEFAULT DETACH KEY: @ (ctrl + 2)"

docker attach --detach-keys="@" mcserver