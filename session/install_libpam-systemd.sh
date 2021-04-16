#!/bin/bash

echo "install libpam-systemd..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_INSTALL=21

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh libpam-systemd || exit $ERROR_CODE_INSTALL

echo "install libpam-systemd success"

exit 0
