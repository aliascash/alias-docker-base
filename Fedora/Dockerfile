# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
#
# SPDX-License-Identifier: MIT

FROM fedora:28
MAINTAINER HLXEasy <hlxeasy@gmail.com>

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

RUN yum update -y

RUN yum install -y \
    less \
    libcap \
    libevent \
    libseccomp \
    libtool \
    libzstd \
    mc \
    obfs4 \
    openssh-clients \
    openssl \
    qt5 \
    qt5-qtwebengine \
    tor \
    wget

COPY spectrecoind.sh /usr/local/bin/spectrecoind.sh
RUN chmod +x /usr/local/bin/spectrecoind.sh

ENTRYPOINT ["/usr/local/bin/spectrecoind.sh"]
