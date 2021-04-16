#!/bin/bash

echo "install xserver..."

ERROR_CODE_SERVICE=10
ERROR_CODE_INSTALL_REQUIRED=100
ERROR_CODE_INSTALL_COMMON=200
ERROR_CODE_INSTALL_TERMINAL=20
ERROR_CODE_INSTALL_FONT=30

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

array=("session/install_libpam-systemd.sh")
SIZE=${#array[@]}
for ((i = 0; i < SIZE; i++)); do
 ITEM="${array[$i]}"
 $DEBIAN_EXTENSION_HOME/$ITEM
 if test $? -ne 0; then
  echo "Install required \"$ITEM\" error!"
  exit $((ERROR_CODE_INSTALL_REQUIRED + i))
 fi
done

array=(\
"xserver/xorg/install.sh" \
"xserver/install_xinit.sh" \
"xserver/install_x11-xserver-utils.sh")
SIZE=${#array[@]}
for ((i = 0; i < SIZE; i++)); do
 ITEM="${array[$i]}"
 $DEBIAN_EXTENSION_HOME/$ITEM
 if test $? -ne 0; then
  echo "Install common \"$ITEM\" error!"
  exit $((ERROR_CODE_INSTALL_COMMON + i))
 fi
done

$DEBIAN_EXTENSION_HOME/xserver/terminal/rxvt-unicode/install_rxvt-unicode.sh
if test $? -ne 0; then
 echo "Install terminal error!"
 exit $ERROR_CODE_INSTALL_TERMINAL
fi

$DEBIAN_EXTENSION_HOME/xserver/font/install_JetBrains_Mono.sh
if test $? -ne 0; then
 echo "Install font error!"
 exit $ERROR_CODE_INSTALL_FONT
fi

echo "install xserver success."

exit 0
