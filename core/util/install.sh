#!/bin/bash

echo "Install util..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi


$DEBIAN_EXTENSION_HOME/common/install_package.sh curl && curl --version || exit 31
$DEBIAN_EXTENSION_HOME/common/install_package.sh openssl && openssl version -a || exit 31
$DEBIAN_EXTENSION_HOME/common/install_package.sh exfat-fuse || exit 32
$DEBIAN_EXTENSION_HOME/common/install_package.sh unzip || exit 32
$DEBIAN_EXTENSION_HOME/common/install_package.sh lbzip2 || exit 32

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
