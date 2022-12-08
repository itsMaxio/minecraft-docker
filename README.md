# Minecraft Server on Docker

Simple local Docker Image for Minecraft Server `vanilla`, `papermc` or custom `server.jar` (forge too).

## How to download

Clone this repo:

```bash
git clone https://github.com/itsMaxio/minecraft-docker
```

Go to the project directory:

```bash
cd minecraft-docker
```

Make scripts executable:

```bash
chmod +x ./*.sh
```

## Before start

Make `.env` file:

```bash
cp .env.example .env
```

Edit variables in `.env` file:

| Name           | Default          | Description                              |   
|----------------|------------------|------------------------------------------|
| `JAVA_VERSION` | **17-jre-focal** | Select Java version                      |
| `VOLUME_PATH`  | **./server**     | Specify local path to files              |
| `LINK`         | empty            | Specify link to a custom **server.jar** (comment or leave empty if you will not use it)|
| `TYPE`         | **papermc**      | Select server type: **vanilla** or **papermc** (or `forge` see below)   |
| `VERSION`      | **1.19.2**       | Select version e.g.: 1.19.2, 1.17.2       |
| `UID`          | **1000**         | Specify the UID of user inside container |
| `MINMEMORY`    | **1G**           | Specify initial memory (-Xmx)            |
| `MAXMEMORY`    | **2G**           | Specify maximum memory (-Xms)            |
| `PORT`         | **25565**        | Specify server port                      |


#### Example `.env`:

```bash
JAVA_VERSION=17-jre-focal           #Select Java version
VOLUME_PATH=./server                #Specify local path to files
#LINK=                              #Download server.jar from link (comment or leave empty if you will not use it)
TYPE=papermc                        #Select server type: vanilla or papermc
VERSION=1.19.2                      #Select version e.g. 1.19.2
UID=1000                            #Specify the UID of user inside container
MINMEMORY=1G                        #Specify initial memory (-Xmx) 
MAXMEMORY=2G                        #Specify maximum memory (-Xms)
PORT=25565                          #Specify server port
```

#### If you want to use `forge` put download link and change `type` to `forge`:

```bash
LINK=https://maven.minecraftforge.net/net/minecraftforge/forge/.../forge-...-installer.jar
TYPE=forge
```
`version` doesn't matter.


#### If you don't create an `.env` file the default value of variables will be used `(via docker-compose.yaml)`:

```bash
JAVA_VERSION=17-jre-focal
VOLUME_PATH=./server
LINK=
TYPE=papermc
VERSION=1.19.2
UID=1000
MINMEMORY=1G
MAXMEMORY=2G
PORT=25565
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
