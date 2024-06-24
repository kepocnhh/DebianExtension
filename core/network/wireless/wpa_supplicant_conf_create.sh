#!/bin/bash

echo 'Create wpa_supplicant.conf...'

if test $# -ne 1; then
 echo "Script needs for 1 arguments but actual $#!"; exit 12; fi

SSID="$1"

for it in SSID; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

echo 'Enter password:'

read -rs PASSWORD

for it in PASSWORD; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

RESULT_FILE_PATH="/etc/wpa_supplicant.$SSID.conf"
if test -f "$RESULT_FILE_PATH"; then
 echo "Config \"$RESULT_FILE_PATH\" already exists!"; exit 21; fi

/usr/bin/wpa_passphrase "$SSID" "$PASSWORD" >> "$RESULT_FILE_PATH"

if test $? -ne 0; then
 echo 'Create wpa_supplicant.conf error!'; rm "$RESULT_FILE_PATH"; exit 14; fi

echo "Create \"$RESULT_FILE_PATH\" success."

exit 0
