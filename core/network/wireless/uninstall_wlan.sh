#!/bin/bash

echo 'Uninstall wlan...'

for it in \
 'firmware-iwlwifi' \
 'libnl-3-200' \
 'libnl-genl-3-200' \
 'iw' \
 'libdbus-1-3' \
 'libnl-route-3-200' \
 'libpcsclite1' \
 'wpasupplicant' \
; do
 /usr/bin/apt-get remove -y "${it}"
 if test $? -ne 0; then
  echo "Uninstall \"$it\" error!"; exit 13; fi
done

echo 'Uninstall wlan success.'

exit 0
