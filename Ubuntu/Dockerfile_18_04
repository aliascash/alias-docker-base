# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
#
# SPDX-License-Identifier: MIT

FROM ubuntu:18.04
MAINTAINER HLXEasy <hlxeasy@gmail.com>

# Build parameters
ARG USERNAME="staker"
ARG GROUPNAME="staker"
ARG PASSWORD="staker123"
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

RUN mkdir -p /home/${USERNAME}/.aliaswallet/tor \
 && touch /home/${USERNAME}/.aliaswallet/tor/torrc \
 && chown -R ${USERNAME}:${GROUPNAME} /home/${USERNAME}/.aliaswallet

RUN apt-get update -y \
 && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    mc \
    libboost-chrono1.65.1 \
    libboost-filesystem1.65.1 \
    libboost-program-options1.65.1 \
    libboost-thread1.65.1 \
    libcap2 \
    libevent-2.1-6 \
    libqt5webchannel5 \
    libtool \
    libseccomp2 \
    obfs4proxy \
    qtwebengine5-dev \
    tor \
    wget

COPY aliaswallet.sh /usr/local/bin/aliaswallet.sh
RUN chmod +x /usr/local/bin/aliaswallet.sh

ENTRYPOINT ["/usr/local/bin/aliaswallet.sh"]
