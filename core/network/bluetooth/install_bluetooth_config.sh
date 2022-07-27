#!/bin/bash

echo "install bluetooth config..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_COPY_CONFIG_FILE=21

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be non-empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi

BLUETOOTH_PATH="$DEBIAN_EXTENSION_HOME/network/bluetooth"
RESOURCE_PATH="$BLUETOOTH_PATH/res"

CONFIG_NAME="main.conf"
RESULT_CONFIG_HOME="/etc/bluetooth"

rm "$RESULT_CONFIG_HOME/$CONFIG_NAME"
mkdir -p "$RESULT_CONFIG_HOME"

cp "$RESOURCE_PATH/$CONFIG_NAME" "$RESULT_CONFIG_HOME"
if test $? -ne 0; then
    echo "Copy config file error!"
    exit $ERROR_CODE_COPY_CONFIG_FILE
fi

echo "install bluetooth config success"

exit 0
