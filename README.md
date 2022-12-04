# Minecraft Server on Docker

Simple local Docker Image for Minecraft Server `vanilla` or `papermc`.

## How to download

Clone this repo

```bash
git clone https://github.com/itsMaxio/minecraft-docker
```

Go to the project directory

```bash
cd minecraft-docker
```

## Before start

If you want to use `docker compose`, you should edit variables in `docker-compose.yaml`:

- `TYPE:` - **vanilla** or **papermc**
- `VERSION:` - e.g.: **1.19.2**
- `MAXMEMORY:` - **2G**
- `MINMEMORY:` - **1G**

and specify `local` directory:

- `"./server:/server"` change `./server` to your location.

#### Example:
```yaml
version: "3.9"

services:
  minecraft:
    build:
      args:
        TYPE: papermc         #Select server type: vanilla or papermc
        VERSION: 1.19.2       #Select version e.g. 1.19.2
    restart: unless-stopped
    container_name: "mcserver"
    environment:
      MAXMEMORY: "2G"         #Specify maximum memory (-Xms)
      MINMEMORY: "1G"         #Specify initial memory (-Xmx)
    volumes:
      - "./server:/server"     #Specify directory where all "server" files are located
    ports:
      - "25565:25565"
    # The following allow `docker attach minecraft` to work
    stdin_open: true
    tty: true
```

## How to start

You can use the script included in this repo

```bash
./start.sh
```

or run it manually `(this prevents duplication of images)`

```bash
docker compose down --rmi all --remove-orphans
```

```bash
docker compose up -d --build
```

## How to stop

You can use the script included in this repo

```bash
./stop.sh
```

or stop it manually

```bash
docker compose down --rmi all --remove-orphans -t 20
```

## How to attach to container

If you want to attach to container or just enter the console use this command:

```bash
docker attach --detach-keys="@" mcserver
```

To detach press `ctrl + 2` (@) or change as you [like](https://docs.docker.com/engine/reference/commandline/attach/#description).

## Sources
Inspired and based on [Docker Minecraft](https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server) by [mtoensing](https://github.com/mtoensing) and [docker-minecraft-server](https://github.com/itzg/docker-minecraft-server) by [itzg](https://github.com/itzg).