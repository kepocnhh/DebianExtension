#!/bin/bash

echo 'Install wlan...'

/usr/bin/apt install -y --no-install-recommends ./wlan/firmware-iwlwifi.deb

if test $? -ne 0; then
 echo 'Install "firmware-iwlwifi" error!'; exit 11; fi

/usr/sbin/modprobe -r iwlmvm && /usr/sbin/modprobe iwlwifi

if test $? -ne 0; then
 echo 'Modprobe error!'; exit 12; fi

for it in \
 'libnl-3-200' \
 'libnl-genl-3-200' \
 'iw' \
 'libdbus-1-3' \
 'libnl-route-3-200' \
 'libpcsclite1' \
 'wpasupplicant' \
; do
 /usr/bin/apt install -y --no-install-recommends ./wlan/${it}.deb
 if test $? -ne 0; then
  echo "Install \"$it\" error!"; exit 13; fi
done

echo 'Install wlan success.'

exit 0
