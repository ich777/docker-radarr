FROM ich777/mono-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-radarr"

RUN apt-get update && \
	apt-get -y install --no-install-recommends mediainfo libicu72 netcat-traditional && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/radarr"
ENV RADARR_REL="latest"
ENV START_PARAMS=""
ENV MONO_START_PARAMS="--debug"
ENV UMASK=0000
ENV DATA_PERM=770
ENV CONNECTED_CONTAINERS=""
ENV CONNECTED_CONTAINERS_TIMEOUT=15
ENV UID=99
ENV GID=100
ENV USER="radarr"

RUN mkdir $DATA_DIR && \
	mkdir /mnt/downloads && \
    mkdir /mnt/movies && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chmod -R 770 /mnt && \
	chown -R $UID:$GID /mnt

EXPOSE 7878

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]