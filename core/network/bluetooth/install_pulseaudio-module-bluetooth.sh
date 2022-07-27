#!/bin/bash

echo "Install pulseaudio-module-bluetooth..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh pulseaudio-module-bluetooth || exit 21

echo "Install pulseaudio-module-bluetooth success"

exit 0
