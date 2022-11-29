#!/bin/bash

echo "Install i3 config..."

for it in HOME DEBIAN_EXTENSION_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

I3_PATH=$DEBIAN_EXTENSION_HOME/xserver/wm/i3
RESULT_DIR="$HOME/.config/i3"

rm $RESULT_DIR/config
mkdir -p $RESULT_DIR

if [ ! -s $I3_PATH/res/config ]; then
 echo "Config i3 does not exist!"; exit 21
fi

cp $I3_PATH/res/config $RESULT_DIR/config
if test $? -ne 0; then
 echo "Copy config file error!"; exit 22
fi

if [ ! -s $I3_PATH/status_command.sh ]; then
 echo "Status command does not exist!"; exit 31
fi

echo "Install i3 config success."
