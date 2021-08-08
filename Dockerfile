FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SABNZBD_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config" \
PYTHONIOENCODING=utf-8

RUN \
  echo "***** install gnupg ****" && \
  apt-get update && \
  apt-get install -y \
    gnupg && \
  echo "***** add sabnzbd repositories ****" && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 0x98703123E0F52B2BE16D586EF13930B14BB9F05F && \
  echo "deb http://ppa.launchpad.net/jcfp/nobetas/ubuntu focal main" >> /etc/apt/sources.list.d/sabnzbd.list && \
  echo "deb-src http://ppa.launchpad.net/jcfp/nobetas/ubuntu focal main" >> /etc/apt/sources.list.d/sabnzbd.list && \
  echo "deb http://ppa.launchpad.net/jcfp/sab-addons/ubuntu focal main" >> /etc/apt/sources.list.d/sabnzbd.list && \
  echo "deb-src http://ppa.launchpad.net/jcfp/sab-addons/ubuntu focal main" >> /etc/apt/sources.list.d/sabnzbd.list && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    libffi-dev \
    libssl-dev \
    p7zip-full \
    par2-tbb \
    python3 \
    python3-cryptography \
    python3-distutils \
    python3-pip \
    python3-setuptools \
    unrar && \
  if [ -z ${SABNZBD_VERSION+x} ]; then \
    SABNZBD_VERSION=$(curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest \
      | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  mkdir -p /app/sabnzbd && \
  curl -o \
    /tmp/sabnzbd.tar.gz -L \
    "https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz" && \
  tar xf \
    /tmp/sabnzbd.tar.gz -C \
    /app/sabnzbd --strip-components=1 && \
  cd /app/sabnzbd && \
  pip3 install -U --no-cache-dir pip && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/ubuntu/ \
    apprise \
    pynzb \
    requests && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/ubuntu/ -r requirements.txt && \
  echo "**** cleanup ****" && \
  ln -s \
    /usr/bin/python3 \
    /usr/bin/python && \
  apt-get purge --auto-remove -y \
    libffi-dev \
    libssl-dev \
    python3-pip && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    $HOME/.cache

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080 9090
VOLUME /config
