#!/bin/bash

echo "install phase 2..."

ERROR_CODE_SERVICE=10
ERROR_CODE_INSTALL_XSERVER=21
ERROR_CODE_INSTALL_WM=22
ERROR_CODE_INSTALL_CHROME=23

if test -z $DEBIAN_EXTENSION_HOME; then
 echo "Debian extension home path is empty!"
 exit $ERROR_CODE_SERVICE
fi

$DEBIAN_EXTENSION_HOME/xserver/install.sh; CODE=$?
if test $CODE -ne 0; then
 echo "Install xserver error $CODE!"
 exit $ERROR_CODE_INSTALL_XSERVER
fi

$DEBIAN_EXTENSION_HOME/xserver/wm/install.sh; CODE=$?
if test $CODE -ne 0; then
 echo "Install wm error $CODE!"
 exit $ERROR_CODE_INSTALL_WM
fi

$DEBIAN_EXTENSION_HOME/xserver/desktop/install_chrome_manual.sh "90.0.4430.72-1"; CODE=$?
if test $CODE -ne 0; then
 echo "Install chrome error $CODE!"
 exit $ERROR_CODE_INSTALL_CHROME
fi

echo "install phase 2 success."

exit 0
