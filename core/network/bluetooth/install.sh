#!/bin/bash

echo "Install bluetooth..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

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

echo "Install bluetooth success."

exit 0
