FROM lsiobase/xenial
MAINTAINER sparklyballs

# environment settings
ENV HOME="/config"
ARG DEBIAN_FRONTEND="noninteractive"

# build packages variable
ARG BUILD_DEPENDENCIES="build-essential debhelper devscripts \
dh-autoreconf git libtbb-dev libwww-perl"

# install packages
RUN \
 echo "deb http://ppa.launchpad.net/jcfp/ppa/ubuntu xenial main" | tee -a /etc/apt/sources.list && \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 0x98703123E0F52B2BE16D586EF13930B14BB9F05F && \
 apt-get update && \
 apt-get install -y \
	libtbb2 \
	p7zip-full \
	sabnzbdplus \
	unrar \
	unzip && \

# install build packages
 apt-get install -y \
	${BUILD_DEPENDENCIES} && \

# install par2 multicore
 apt-get purge -y --auto-remove \
	par2 && \
 git clone https://github.com/jcfp/debpkg-par2tbb.git \
	/tmp/par2-src && \
 cd /tmp/par2-src && \
 uscan \
	--force-download && \
 dpkg-buildpackage \
	-S -us -uc -d && \
 dpkg-source \
	-x ../par2cmdline-tbb_*.dsc && \
 cd par2cmd* && \
 ./configure \
	--prefix=/usr \
	--includedir=${prefix}/include \
	--mandir=${prefix}/share/man \
	--infodir=${prefix}/share/info \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--disable-silent-rules \
	--libdir=${prefix}/lib/arm-linux-gnu \
	--libexecdir=${prefix}/lib/arm-linux-gnu && \
 make && \
 make install && \

# cleanup
 apt-get purge -y --auto-remove \
	${BUILD_DEPENDENCIES} && \
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
