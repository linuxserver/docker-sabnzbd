FROM lsiobase/alpine.python
MAINTAINER sparklyballs

# build arguements
ARG SAB_MAIN="1.1.0"
ARG SAB_VER="RC4"
ARG SAB_BUILD="${SAB_MAIN}${SAB_VER}"

# install sabnzbd
RUN \
 mkdir -p \
	/app/sabnzbd && \
 curl -o \
 /tmp/sabnzbd.tar.gz -L \
	"https://github.com/sabnzbd/sabnzbd/releases/download/${SAB_BUILD}/SABnzbd-${SAB_BUILD}-src.tar.gz" && \
 tar xf \
 /tmp/sabnzbd.tar.gz -C \
	/app/sabnzbd --strip-components=1 && \

# cleanup
 rm -f \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /downloads /incomplete-downloads
EXPOSE 8080 9090

