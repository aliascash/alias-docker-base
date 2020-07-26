#!/bin/bash
# ===========================================================================
#
# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
# SPDX-License-Identifier: MIT
#
# Creation: 2018-07-29 hlxeasy
#
# Simple spectrecoin entry script to start spectrecoind on Docker container
#
# ============================================================================

if [ -e $HOME/.spectrecoin/spectrecoin.conf ] ; then
    # spectrecoin.conf found, try to update it
    if $(grep -q "rpcuser=" $HOME/.spectrecoin/spectrecoin.conf) ; then
        # Var rpcuser found, update it
        if [ -n "${RPCUSER}" ] ; then
            sed -i "s/rpcuser=.*$/rpcuser=${RPCUSER}/g" $HOME/.spectrecoin/spectrecoin.conf
        fi
    else
        # Var rpcuser not found but required, create it
        echo "rpcuser=spectrecoinrpc" >> $HOME/.spectrecoin/spectrecoin.conf
    fi
    if $(grep -q "rpcpassword=" $HOME/.spectrecoin/spectrecoin.conf) ; then
        # Var rpcuser found, update it
        if [ -n "${RPCPASSWORD}" ] ; then
            sed -i "s/rpcpassword=.*$/rpcpassword=${RPCPASSWORD}/g" $HOME/.spectrecoin/spectrecoin.conf
        fi
    else
        # Var rpcpassword not found but required, create it
        rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 44 | head -n 1)
        echo "rpcpassword=${rpcpassword}" >> $HOME/.spectrecoin/spectrecoin.conf
    fi
else
    # spectrecoin.conf not found, create it with minimal content
    echo "rpcuser=spectrecoinrpc" > $HOME/.spectrecoin/spectrecoin.conf
    rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 44 | head -n 1)
    echo "rpcpassword=${rpcpassword}" >> $HOME/.spectrecoin/spectrecoin.conf
fi

/usr/local/bin/spectrecoind
