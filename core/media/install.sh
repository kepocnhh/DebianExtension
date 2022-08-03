#!/bin/bash

echo "Install media..."

for it in HOME DEBIAN_EXTENSION_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ARRAY=("alsa-utils" pulseaudio playerctl)
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 $DEBIAN_EXTENSION_HOME/common/install_package.sh "${ARRAY[$i]}" || exit $((20 + i))
done

mkdir -p $HOME/.config/systemd/user
ln -s /dev/null $HOME/.config/systemd/user/pulseaudio.socket

aplay --version
pulseaudio --version
playerctl --version

exit 0
