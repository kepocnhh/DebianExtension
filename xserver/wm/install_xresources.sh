#!/bin/bash

echo "Install xresources..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
elif [ ! -d "$HOME" ]; then
 echo "Dir $HOME does not exist!"; exit 12
fi

RESULT_PATH="$HOME/.Xresources"

rm $RESULT_PATH

cp $DEBIAN_EXTENSION_HOME/xserver/wm/res/.Xresources $RESULT_PATH
if test $? -ne 0; then
 echo "Copy xresources file error!"; exit 21
fi

exit 0
