FROM lsiobase/alpine.python
MAINTAINER sparklyballs

# install sabnzbd
RUN \
 mkdir -p \
	/app/sabnzbd && \
 LATEST_RELEASE=$(curl -sX GET "https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest" | \
	awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o \
 /tmp/sabnzbd.tar.gz -L \
	https://github.com/sabnzbd/sabnzbd/releases/download/"${LATEST_RELEASE}"/SABnzbd-"${LATEST_RELEASE}"-src.tar.gz && \

 tar xf \
 /tmp/sabnzbd.tar.gz -C \
	/app/sabnzbd --strip-components=1 && \

# cleanup
 rm -f \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /downloads /incomplete-downloads
EXPOSE 8080 9090
