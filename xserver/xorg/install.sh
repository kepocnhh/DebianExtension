#!/bin/bash

echo "install xorg..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_INSTALL=200

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi

ARRAY=(\
"intel/install_intel_config.sh" \
"install_xserver-xorg-core.sh" \
"install_xserver-xorg-input-all.sh")
SIZE=${#ARRAY[@]}
for ((i = 0; i < SIZE; i++)); do
 ITEM="${ARRAY[$i]}"
 $DEBIAN_EXTENSION_HOME/xserver/xorg/$ITEM
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"
  exit $((ERROR_CODE_INSTALL + i))
 fi
done

echo "install xorg success."

exit 0
