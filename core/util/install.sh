#!/bin/bash

echo 'Install util...'

ARRAY=(curl openssl 'exfat-fuse' unzip lbzip2 xz-utils gpg 'gpg-agent' dirmngr jq ntp)
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 apt-get install --no-install-recommends -y "${ARRAY[$i]}" || exit $((30 + i))
done

ARRAY=(default 'usb_mount_service' git)
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 ./core/util/install_${ITEM}.sh
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"; exit $((20 + i)); fi
done

/usr/bin/timedatectl set-timezone 'Europe/Moscow'
ntpq -p

echo 'Install util success.'

exit 0
