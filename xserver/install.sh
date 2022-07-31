#!/bin/bash

echo "Install xserver..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

ARRAY=("libpam-systemd" xinit "x11-xserver-utils" "x11-utils" "dbus-x11")
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 $DEBIAN_EXTENSION_HOME/common/install_package.sh "${ARRAY[$i]}" || exit $((20 + i))
done

touch $HOME/.bash_aliases
echo "alias sx=\"/usr/bin/startx && exit\"" >> $HOME/.bash_aliases

$DEBIAN_EXTENSION_HOME/xserver/xorg/install.sh || exit 31

$DEBIAN_EXTENSION_HOME/common/install_package.sh rxvt-unicode || exit 41
$DEBIAN_EXTENSION_HOME/xserver/font/install_JetBrains_Mono.sh || exit 42

$DEBIAN_EXTENSION_HOME/xserver/wm/instal.sh || exit 31

echo "Install xserver success."

exit 0
