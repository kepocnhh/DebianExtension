#!/bin/bash

echo "install util..."

ERROR_CODE_SERVICE=1
ERROR_CODE_INSTALL=100

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

array=("curl" "default" "exfat-fuse" "openssl" "unzip" "usb_mount_service")
SIZE=${#array[@]}
for ((i = 0; i < SIZE; i++)); do
 ITEM="${array[$i]}"
 $DEBIAN_EXTENSION_HOME/util/install_${ITEM}.sh
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"
  exit $((ERROR_CODE_INSTALL + i))
 fi
done

echo "install util success."

exit 0
