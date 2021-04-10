#!/bin/bash

echo "install media..."

ERROR_CODE_SERVICE=1
ERROR_CODE_INSTALL_COMMON=200

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

array=(\
"audio/install_alsa-utils.sh" \
"audio/install_pulseaudio.sh" \
"install_playerctl.sh")
SIZE=${#array[@]}
for ((i = 0; i < SIZE; i++)); do
 ITEM="${array[$i]}"
 $DEBIAN_EXTENSION_HOME/media/$ITEM
 if test $? -ne 0; then
  echo "Install common \"$ITEM\" error!"
  exit $((ERROR_CODE_INSTALL_COMMON + i))
 fi
done

echo "install media success."

exit 0
