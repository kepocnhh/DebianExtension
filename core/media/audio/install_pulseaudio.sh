#!/bin/bash

echo "install pulseaudio..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_INSTALL=21

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh pulseaudio || exit $ERROR_CODE_INSTALL

pulseaudio --version

echo "install pulseaudio success"

exit 0
