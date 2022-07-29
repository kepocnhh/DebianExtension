#!/bin/bash

echo "Install i3 config..."

ERROR_CODE_COPY_CONFIG_STATUS_FILE=31
ERROR_CODE_MAKE_BIN_DIR=41
ERROR_CODE_COPY_COMMAND=51

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
elif [ ! -d "$HOME" ]; then
 echo "Dir $HOME does not exist!"; exit 12
fi

I3_PATH=$DEBIAN_EXTENSION_HOME/xserver/wm/i3
RESOURCE_PATH=$I3_PATH/res
RESULT_CONFIG_PATH="$HOME/.config/i3/config"

rm $RESULT_CONFIG_PATH
mkdir -p "$HOME/.config/i3"

cp $RESOURCE_PATH/config $RESULT_CONFIG_PATH
if test $? -ne 0; then
 echo "Copy config file error!"; exit 21
fi

BIN_PATH="$HOME/.local/bin"
if test ! -d "$BIN_PATH"; then
 mkdir -p "$BIN_PATH"
 if test $? -ne 0; then
  echo "Make bin dir $BIN_PATH error!"; exit 22
 fi
fi

COMMAND_NAME="status_command.sh"
rm "$BIN_PATH/$COMMAND_NAME"
cp "$I3_PATH/$COMMAND_NAME" "$BIN_PATH/$COMMAND_NAME"
if test $? -ne 0; then
 echo "Copy \"$COMMAND_NAME\" command file error!"; exit 23
fi

COMMAND_NAME="on_idle_command.sh"
rm "$BIN_PATH/$COMMAND_NAME"
cp "$I3_PATH/$COMMAND_NAME" "$BIN_PATH/$COMMAND_NAME"
if test $? -ne 0; then
 echo "Copy \"$COMMAND_NAME\" command file error!"; exit 24
fi

echo "Install i3 config success."

exit 0
