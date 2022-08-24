#!/bin/bash

echo "Install bluetooth..."

for it in HOME DEBIAN_EXTENSION_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

$DEBIAN_EXTENSION_HOME/common/install_package.sh pulseaudio-module-bluetooth || exit 21
mkdir -p /etc/bluetooth/
cp $DEBIAN_EXTENSION_HOME/debian/etc/bluetooth/main.conf /etc/bluetooth/main.conf || exit 22

mkdir $HOME/.local
echo "
alias bt=/usr/bin/bluetoothctl
alias btc=\"bt connect\"
alias btdc=\"bt disconnect\"
" >> $HOME/.local/aliases

echo "Install bluetooth success."
