#!/bin/bash

echo "install wm..."

ERROR_CODE_SERVICE=10
ERROR_CODE_INSTALL_DMENU=20
ERROR_CODE_INSTALL_XRESOURCES=30
ERROR_CODE_INSTALL_I3=100

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

$DEBIAN_EXTENSION_HOME/xserver/wm/install_dmenu.sh
if test $? -ne 0; then
 echo "Install dmenu error!"
 exit $ERROR_CODE_INSTALL_DMENU
fi

$DEBIAN_EXTENSION_HOME/xserver/wm/install_xresources.sh
if test $? -ne 0; then
 echo "Install xresources error!"
 exit $ERROR_CODE_INSTALL_XRESOURCES
fi

array=("i3" "i3_config" "i3lock")
SIZE=${#array[@]}
for ((i = 0; i < SIZE; i++)); do
 ITEM="${array[$i]}"
 $DEBIAN_EXTENSION_HOME/xserver/wm/i3/install_${ITEM}.sh
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"
  exit $((ERROR_CODE_INSTALL_I3 + i))
 fi
done

echo "install wm success."

exit 0
