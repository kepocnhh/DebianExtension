#!/bin/bash

echo "Install bluetooth config..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

BLUETOOTH_PATH="$DEBIAN_EXTENSION_HOME/core/network/bluetooth"
RESOURCE_PATH="$BLUETOOTH_PATH/res"

CONFIG_NAME="main.conf"
RESULT_CONFIG_HOME="/etc/bluetooth"

rm "$RESULT_CONFIG_HOME/$CONFIG_NAME"
mkdir -p "$RESULT_CONFIG_HOME"

cp "$RESOURCE_PATH/$CONFIG_NAME" "$RESULT_CONFIG_HOME"
if test $? -ne 0; then
 echo "Copy config file error!"; exit 21
fi

echo "Install bluetooth config success"

exit 0
