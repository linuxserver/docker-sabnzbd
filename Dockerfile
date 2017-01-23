FROM lsiobase/xenial
MAINTAINER sparklyballs

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config"

# build packages as variable
ARG BUILD_PACKAGES="\
	build-essential \
	debhelper \
	devscripts \
	dh-autoreconf \
	git \
	libtbb-dev"

# install packages
RUN \
 echo "deb http://ppa.launchpad.net/jcfp/ppa/ubuntu xenial main" | tee -a /etc/apt/sources.list && \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 0x98703123E0F52B2BE16D586EF13930B14BB9F05F && \
 apt-get update && \
 apt-get install -y \
	p7zip-full \
	libtbb2 \
	sabnzbdplus \
	unrar \
	ffmpeg \
	mkvtoolnix \
	python-pip \
	python-subliminal \
	python-guessit \
	unzip && \

# install build packages
 apt-get install -y \
	$BUILD_PACKAGES && \

# compile par2 multicore
 apt-get remove -y \
	par2 && \
 git clone https://github.com/jcfp/debpkg-par2tbb.git \
	/tmp/par2 && \
 cd /tmp/par2 && \
 uscan --force-download && \
 dpkg-buildpackage -S -us -uc -d && \
 dpkg-source -x ../par2cmdline-tbb_*.dsc && \
 cd /tmp/par2/par2cmdline-tbb-* && \
 dpkg-buildpackage -b -us -uc && \
 dpkg -i $(readlink -f ../par2-tbb_*.deb) && \

# necessary for mp4_automator
 pip install qtfaststart && \
 git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git /mp4_automator && \

# cleanup
 apt-get purge -y --auto-remove \
	$BUILD_PACKAGES && \
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
