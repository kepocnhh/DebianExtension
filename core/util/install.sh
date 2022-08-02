#!/bin/bash

echo "Install util..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

ARRAY=(curl openssl "exfat-fuse" unzip lbzip2 xz-utils gpg "gpg-agent")
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 $DEBIAN_EXTENSION_HOME/common/install_package.sh "${ARRAY[$i]}"; exit $((30 + i))
done

ARRAY=(default "usb_mount_service" git)
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 $DEBIAN_EXTENSION_HOME/core/util/install_${ITEM}.sh
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"; exit $((20 + i))
 fi
done

echo "Install util success."

exit 0
