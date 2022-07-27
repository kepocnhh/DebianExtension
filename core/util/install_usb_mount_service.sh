#!/bin/bash

echo "Install mount service..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

CODE=0

FILE_NAME="99-usb-mount.rules"
cp $DEBIAN_EXTENSION_HOME/core/util/mount/res/$FILE_NAME /etc/udev/rules.d/$FILE_NAME
if test $? -ne 0; then
 echo "Copy mount rules error!"; exit 21
fi

FILE_NAME="usb-mount@.service"
cp $DEBIAN_EXTENSION_HOME/core/util/mount/res/$FILE_NAME /lib/systemd/system/$FILE_NAME
if test $? -ne 0; then
 echo "Copy mount service error!"; exit 22
fi

FILE_NAME="usb_mount.sh"
cp $DEBIAN_EXTENSION_HOME/core/util/mount/$FILE_NAME /usr/local/bin/$FILE_NAME
if test $? -ne 0; then
 echo "Copy mount script error!"; exit 23
fi

FILE_NAME="usb_umount.sh"
cp $DEBIAN_EXTENSION_HOME/core/util/mount/$FILE_NAME /usr/local/bin/$FILE_NAME
if test $? -ne 0; then
 echo "Copy umount script error!"; exit 24
fi

udevadm control --reload-rules
if test $? -ne 0; then
 echo "Reload rules error!"; exit 25
fi

/usr/bin/systemctl daemon-reload
if test $? -ne 0; then
 echo "Daemon reload error!"; exit 26
fi

echo "Install mount service success."

exit 0
