#!/bin/bash

useradd -s /bin/bash -u ${UID} minecraft

chown -R "$UID":"$UID" /server