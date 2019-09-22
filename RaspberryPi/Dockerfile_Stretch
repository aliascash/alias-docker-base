FROM arm32v7/debian:stretch-slim
MAINTAINER HLXEasy <hlxeasy@gmail.com>

COPY RaspberryPi/qemu-arm-static /usr/bin
COPY Debian/stretch-backports.list /etc/apt/sources.list.d/

# Build parameters
ARG USERNAME="spectre"
ARG GROUPNAME="spectre"
ARG PASSWORD="spectre123"
ARG UID="1000"
ARG GID="1000"

# Setup spectre account
# Create working directory
# Change user UID and GID
RUN groupadd --gid ${GID} $GROUPNAME \
 && useradd --create-home --home-dir /home/$USERNAME --shell /bin/bash --uid ${UID} --gid ${GID} $USERNAME \
 && echo "$USERNAME:$PASSWORD" | chpasswd \
 && chown $USERNAME:$GROUPNAME /home/$USERNAME -R \
 && ulimit -v unlimited

RUN mkdir -p /home/${USERNAME}/.spectrecoin/tor \
 && touch /home/${USERNAME}/.spectrecoin/tor/torrc \
 && chown -R ${USERNAME}:${GROUPNAME} /home/${USERNAME}/.spectrecoin

RUN apt-get update -y \
 && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    mc \
    libboost-chrono1.67.0 \
    libboost-filesystem1.67.0 \
    libboost-program-options1.67.0 \
    libboost-thread1.67.0 \
    libevent-2.0-5 \
    libgles2-mesa \
    libqt5webchannel5 \
    libqt5webenginewidgets5 \
    libtool \
    libseccomp2 \
    obfs4proxy \
    tor \
    wget

# Latest and greatest version of 'dialog' is compiled on corresponding builder image,
# So install dialog dependencies manually as long as the real package is not up2date
# See https://packages.debian.org/stretch/dialog
RUN apt-get install -y --no-install-recommends \
    debianutils \
    libc6 \
    libncursesw5 \
    libtinfo5

COPY spectrecoind.sh /usr/local/bin/spectrecoind.sh
RUN chmod +x /usr/local/bin/spectrecoind.sh

ENTRYPOINT ["/usr/local/bin/spectrecoind.sh"]
