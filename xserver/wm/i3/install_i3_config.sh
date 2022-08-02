#!/bin/bash

echo "Install i3 config..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
elif [ ! -d "$HOME" ]; then
 echo "Dir $HOME does not exist!"; exit 12
fi

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
elif [ ! -s $I3_PATH/on_idle_command.sh ]; then
 echo "On idle command does not exist!"; exit 32
fi

echo "Install i3 config success."

exit 0
