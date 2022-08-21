#!/bin/bash

echo "Install session..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

ARRAY=(dbus "libpam-systemd")
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 $DEBIAN_EXTENSION_HOME/common/install_package.sh "${ARRAY[$i]}" || exit $((20 + i))
done

echo "Install session success."

exit 0
