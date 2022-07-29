#!/bin/bash

echo "Install xserver..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

ITEM="libpam-systemd"
$DEBIAN_EXTENSION_HOME/common/install_package.sh "$ITEM"
if test $? -ne 0; then
 echo "Install \"$ITEM\" error!"; exit 21
fi

ARRAY=(\
"xserver/install_xinit.sh" \
"xserver/install_x11-xserver-utils.sh" \
"xserver/xorg/install.sh")
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 $DEBIAN_EXTENSION_HOME/$ITEM
 if test $? -ne 0; then
  echo "Install common \"$ITEM\" error!"
  exit $((30 + i))
 fi
done

$DEBIAN_EXTENSION_HOME/common/install_package.sh rxvt-unicode
if test $? -ne 0; then
 echo "Install terminal error!"; exit 41
fi

$DEBIAN_EXTENSION_HOME/xserver/font/install_JetBrains_Mono.sh
if test $? -ne 0; then
 echo "Install font error!"; exit 42
fi

echo "Install xserver success."

exit 0
