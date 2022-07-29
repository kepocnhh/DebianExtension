#!/bin/bash

if [ ! -d "$HOME" ]; then
 echo "Dir $HOME does not exist!"; exit 11
fi

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 12
fi

MAC_ADDRESS=$1

for it in MAC_ADDRESS; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

CONFIG_PATH="$HOME/.config/i3/config"

if [ ! -s "$CONFIG_PATH" ]; then
 echo "File $CONFIG_PATH does not exist!"; exit 14
fi

MAC_ADDRESS="${MAC_ADDRESS//:/_}"
echo "bindsym XF86AudioMute exec pactl set-sink-mute bluez_sink.${MAC_ADDRESS}.a2dp_sink toggle" >> $CONFIG_PATH
if test $? -ne 0; then
 echo "Set sink mute error!"; exit 21
fi

exit 0
