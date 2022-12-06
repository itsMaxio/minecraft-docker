ARG JAVA_VERSION=17-jre-focal



FROM ubuntu:20.04 AS jarbuild

RUN apt update && apt install -y \
    curl \
    jq

WORKDIR /scripts
COPY --chmod=755 ./scripts/ .

ARG LINK
ARG TYPE=papermc
ARG VERSION=1.19.2

RUN ./getjar.sh



FROM eclipse-temurin:${JAVA_VERSION}

STOPSIGNAL SIGINT

ENV UID=1000

VOLUME "/server"
WORKDIR /server
COPY --from=jarbuild /scripts /scripts

RUN apt-get update && \
    apt-get install -y gosu && \
    rm -rf /var/lib/apt/lists/* && \
    gosu nobody true

ENTRYPOINT [ "/scripts/start_server.sh" ]