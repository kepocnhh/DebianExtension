#!/bin/bash

echo 'Install media...'

for it in HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ARRAY=('alsa-utils' pulseaudio playerctl)
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 ./common/install_package.sh "$ITEM"
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"; exit $((20 + i)); fi
done

mkdir -p "$HOME/.config/systemd/user"
ln -s /dev/null "$HOME/.config/systemd/user/pulseaudio.socket"
echo "/usr/bin/pulseaudio --check || /usr/bin/pulseaudio --start" >> $HOME/.xsessionrc

aplay --version
pulseaudio --version
playerctl --version

exit 0
