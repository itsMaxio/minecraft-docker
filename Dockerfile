ARG JAVA_VERSION=17-focal

FROM eclipse-temurin:${JAVA_VERSION}

STOPSIGNAL SIGTERM

ENV UID=1000
ENV GID=1000
ENV MIN_MEMORY=1G
ENV MAX_MEMORY=2G
ENV TYPE=file

COPY scripts /scripts

VOLUME [ "/server" ]
WORKDIR /server

RUN apt-get update && \
    apt-get install -y gosu dos2unix && \
    dos2unix /scripts/* && \
    apt-get --purge remove -y dos2unix && \
    rm -rf /var/lib/apt/lists/* && \
    gosu nobody true

ENTRYPOINT [ "/scripts/start.sh" ]