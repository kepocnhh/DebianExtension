#!/bin/bash

echo 'Install xserver...'

for it in HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ARRAY=('libpam-systemd' xinit 'x11-xserver-utils' 'x11-utils' 'dbus-x11')
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 apt-get install --no-install-recommends -y "${ARRAY[$i]}" || exit $((20 + i))
done

mkdir $HOME/.local
# echo "alias sx=\"/usr/bin/startx; exit\"" >> $HOME/.local/aliases # todo

./xserver/xorg/install.sh || exit 31

apt-get install --no-install-recommends -y rxvt-unicode || exit 41
./xserver/font/install_JetBrains_Mono.sh || exit 42

./xserver/wm/install.sh || exit 31

echo 'Install xserver success.'

exit 0
