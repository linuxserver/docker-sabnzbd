FROM linuxserver/baseimage
MAINTAINER Mark Burford <sparklyballs@gmail.com>

# Set the locale
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8

# install our compiled version of par2 multicore
ADD deb/ /tmp/
RUN apt-get update -q && \
apt-get install libtbb2 -qy && \
dpkg -i /tmp/par2-tbb_*.deb && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install main packages
RUN add-apt-repository ppa:jcfp/ppa && \
apt-get update -q && \
apt-get install \
curl \
sabnzbdplus \ 
sabnzbdplus-theme-mobile \ 
unrar \
wget -qy && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set volumes
VOLUME /config /downloads /incomplete-downloads

# expose ports
EXPOSE 8080 9090

# adding custom files
ADD services/ /etc/service/
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/service/*/run
RUN chmod -v +x /etc/my_init.d/*.sh

