#!/bin/bash

echo "Install intel config..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_COPY_CONFIG_FILE=21

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

INTEL_PATH="$DEBIAN_EXTENSION_HOME/xserver/xorg/intel"
RESOURCE_PATH="$INTEL_PATH/res"

CONFIG_NAME="20-intel.conf"
RESULT_CONFIG_HOME="/etc/X11/xorg.conf.d"

rm "$RESULT_CONFIG_HOME/$CONFIG_NAME"
mkdir -p "$RESULT_CONFIG_HOME"

cp "$RESOURCE_PATH/$CONFIG_NAME" "$RESULT_CONFIG_HOME"
if test $? -ne 0; then
 echo "Copy config file error!"; exit 21
fi

echo "Install intel config success."

exit 0
