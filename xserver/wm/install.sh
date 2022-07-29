#!/bin/bash

echo "Install wm..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh dmenu
if test $? -ne 0; then
 echo "Install dmenu error!"; exit 21
fi

$DEBIAN_EXTENSION_HOME/xserver/wm/install_xresources.sh
if test $? -ne 0; then
 echo "Install xresources error!"; exit 22
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh i3 \
 && $DEBIAN_EXTENSION_HOME/common/install_package.sh i3lock \
 && $DEBIAN_EXTENSION_HOME/xserver/wm/i3/install_i3_config.sh
if test $? -ne 0; then
 echo "Install i3 error!"; exit 31
fi

echo "Install wm success."

exit 0
