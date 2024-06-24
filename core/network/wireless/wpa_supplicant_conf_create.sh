#!/bin/bash

echo 'Create wpa_supplicant.conf...'

if test $# -ne 1; then
 echo "Script needs for 2 arguments but actual $#!"; exit 12; fi

SSID="$1"
PASSWORD="$2"

for it in SSID PASSWORD; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

TMP_FILE_PATH="/tmp/wpa_supplicant.tmp.conf"

STATUS=0

/usr/bin/wpa_passphrase "$SSID" "$PASSWORD" >> "$TMP_FILE_PATH"

if test $? -ne 0; then
 echo 'Create wpa_supplicant.conf error!'; rm "$TMP_FILE_PATH"; exit 14; fi

RESULT_FILE_PATH="/etc/wpa_supplicant.$SSID.conf"
mv "$TMP_FILE_PATH" "$RESULT_FILE_PATH"

if test $? -ne 0; then
 echo 'Move wpa_supplicant.conf error!'; rm "$TMP_FILE_PATH"; exit 15; fi

echo "Create \"$RESULT_FILE_PATH\" success."

exit 0
