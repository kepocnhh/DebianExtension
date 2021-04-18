#!/bin/bash

echo "install bluetooth..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_INSTALL=200

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi

ARRAY=(\
"bluetooth_config" \
"pulseaudio-module-bluetooth")
SIZE=${#ARRAY[@]}
for ((i = 0; i < SIZE; i++)); do
 ITEM="${ARRAY[$i]}"
 $DEBIAN_EXTENSION_HOME/network/bluetooth/install_${ITEM}.sh
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"
  exit $((ERROR_CODE_INSTALL + i))
 fi
done

echo "install bluetooth success."

exit 0
