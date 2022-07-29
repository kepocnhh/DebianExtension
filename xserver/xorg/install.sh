#!/bin/bash

echo "Install xorg..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

ARRAY=("core" "input-all" "video-intel")
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 $DEBIAN_EXTENSION_HOME/common/install_package.sh "xserver-xorg-${ITEM}"
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"; exit $((20 + i))
 fi
done

$DEBIAN_EXTENSION_HOME/xserver/xorg/intel/install_intel_config.sh || exit 31

echo "Install xorg success."

exit 0
