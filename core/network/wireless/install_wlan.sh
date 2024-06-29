#!/bin/bash

echo 'Install wlan...'

/usr/bin/apt install -y --no-install-recommends ./wlan/firmware-iwlwifi_*

if test $? -ne 0; then
 echo 'Install "firmware-iwlwifi" error!'; exit 11; fi

/usr/sbin/modprobe -r iwlmvm && /usr/sbin/modprobe iwlwifi

if test $? -ne 0; then
 echo 'Modprobe error!'; exit 12; fi

for it in \
 './wlan/libnl-3-200_*' \
 './wlan/libnl-genl-3-200_*' \
 './wlan/iw_*' \
 './wlan/libdbus-1-3_*' \
 './wlan/libnl-route-3-200_*' \
 './wlan/libpcsclite1_*' \
 './wlan/wpasupplicant_*' \
; do
 /usr/bin/apt install -y --no-install-recommends $it
 if test $? -ne 0; then
  echo "Install \"$it\" error!"; exit 13; fi
done

echo 'Install wlan success.'

exit 0
