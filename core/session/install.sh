#!/bin/bash

echo 'Install session...'

ARRAY=(dbus 'libpam-systemd')
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 apt-get install --no-install-recommends -y "$ITEM"
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"; exit $((20 + i)); fi
done

echo 'Install session success.'

exit 0
