FROM ubuntu:16.04

MAINTAINER z4yx <z4yx@users.noreply.github.com>

# build with docker build --build-arg PETA_VERSION=2018.1 --build-arg PETA_RUN_FILE=petalinux-v2018.1-final-installer.run -t petalinux:2018.1 .

#install dependences:
RUN sed -i.bak s/archive.ubuntu.com/mirror.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
  dpkg --add-architecture i386 && apt-get update && apt-get install -y \
  build-essential \
  sudo \
  tofrodos \
  iproute2 \
  gawk \
  net-tools \
  expect \
  libncurses5-dev \
  tftpd \
  libssl-dev \
  flex \
  bison \
  libselinux1 \
  gnupg \
  wget \
  socat \
  gcc-multilib \
  libsdl1.2-dev \
  libglib2.0-dev \
  lib32z1-dev \
  zlib1g:i386 \
  screen \
  pax \
  diffstat \
  xvfb \
  xterm \
  texinfo \
  gzip \
  unzip \
  cpio \
  chrpath \
  autoconf \
  lsb-release \
  libtool \
  locales \
  git

ARG PETA_VERSION
ARG PETA_RUN_FILE

RUN locale-gen en_US.UTF-8 && update-locale

#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado
RUN usermod -aG sudo vivado
RUN echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/vivado

COPY accept-eula.sh ${PETA_RUN_FILE} /

# run the install
RUN chmod a+x /${PETA_RUN_FILE} && \
  mkdir -p /opt/Xilinx && \
  chmod 777 /opt/Xilinx && \
  sudo -u vivado /accept-eula.sh /${PETA_RUN_FILE} /opt/Xilinx/petalinux && \
  rm -f /${PETA_RUN_FILE} /accept-eula.sh 

USER vivado
ENV HOME /home/vivado
ENV PETA_VERSION ${PETA_VERSION}

#add vivado tools to path
RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/vivado/.bashrc

