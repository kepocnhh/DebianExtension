#!/bin/bash

echo "Install playerctl..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh playerctl || exit 21

playerctl --version

echo "Install playerctl success."

exit 0
