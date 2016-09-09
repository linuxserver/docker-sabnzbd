FROM lsiobase/xenial
MAINTAINER sparklyballs

# environment settings
ENV HOME="/config"
ARG DEBIAN_FRONTEND="noninteractive"

# install packages
RUN \
 echo "deb http://ppa.launchpad.net/jcfp/ppa/ubuntu xenial main" | tee -a /etc/apt/sources.list && \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 0x98703123E0F52B2BE16D586EF13930B14BB9F05F && \
 apt-get update && \
 apt-get install -y \
	p7zip-full \
	sabnzbdplus \
	unrar \
	unzip && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080 9090
VOLUME /config /downloads /incomplete-downloads
