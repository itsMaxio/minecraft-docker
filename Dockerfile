FROM ubuntu:20.04 AS jarbuild

WORKDIR /scripts

COPY ./scripts/ .

RUN apt update && apt install -y \
    curl \
    jq

ARG TYPE=papermc
ARG VERSION=1.19

RUN ./getjar.sh


# ARG JAVA_VERSION=17
FROM eclipse-temurin:17-jre-focal

VOLUME "/server"
WORKDIR /server

COPY --from=jarbuild /scripts /scripts

ENTRYPOINT [ "/scripts/start_server.sh" ]