#!/bin/bash

echo "Install bluetooth..."

for it in HOME DEBIAN_EXTENSION_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ARRAY=(\
"pulseaudio-module-bluetooth" \
"bluetooth_config")
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 $DEBIAN_EXTENSION_HOME/core/network/bluetooth/install_${ITEM}.sh
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"; exit $((20 + i))
 fi
done

mkdir $HOME/.local
echo "
alias bt=/usr/bin/bluetoothctl
alias btc=\"bt connect\"
alias btdc=\"bt disconnect\"
" >> $HOME/.local/aliases

echo "Install bluetooth success."

exit 0
