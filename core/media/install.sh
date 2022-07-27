#!/bin/bash

echo "Install media..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

ARRAY=(\
"audio/install_alsa-utils.sh" \
"audio/install_pulseaudio.sh" \
"install_playerctl.sh")
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 $DEBIAN_EXTENSION_HOME/core/media/$ITEM
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"; exit $((20 + i))
 fi
done

echo "Install media success."

exit 0
