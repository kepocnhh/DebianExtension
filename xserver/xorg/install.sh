#!/bin/bash

echo 'Install xorg...'

ARRAY=(core 'input-all' 'video-intel')
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 apt-get install --no-install-recommends -y "xserver-xorg-${ITEM}"
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"; exit $((20 + i)); fi
done

./xserver/xorg/intel/install_intel_config.sh || exit 31

echo 'Install xorg success.'

exit 0
