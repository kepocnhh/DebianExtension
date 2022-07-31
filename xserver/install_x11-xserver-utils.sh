#!/bin/bash

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh x11-xserver-utils || exit 21
$DEBIAN_EXTENSION_HOME/common/install_package.sh dbus-x11 || exit 22

xrdb -version

exit 0
