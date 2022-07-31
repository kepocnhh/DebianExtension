#!/bin/bash

echo "Install xserver..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh libpam-systemd || exit 21
$DEBIAN_EXTENSION_HOME/common/install_package.sh xinit || exit 22
$DEBIAN_EXTENSION_HOME/common/install_package.sh x11-xsxerver-utils || exit 23
$DEBIAN_EXTENSION_HOME/common/install_package.sh dbus-x11 || exit 24

touch $HOME/.bash_aliases
echo "alias sx=\"/usr/bin/startx && exit\"" >> $HOME/.bash_aliases

$DEBIAN_EXTENSION_HOME/xserver/xorg/instal.sh || exit 31

$DEBIAN_EXTENSION_HOME/common/install_package.sh rxvt-unicode || exit 41
$DEBIAN_EXTENSION_HOME/xserver/font/install_JetBrains_Mono.sh || exit 42

echo "Install xserver success."

exit 0
