#!/bin/bash

echo "install mount service..."

ERROR_CODE_SERVICE=1
ERROR_CODE_COPY_RULES=2
ERROR_CODE_COPY_SERVICE=3
ERROR_CODE_COPY_MOUNT_SCRIPT=4
ERROR_CODE_COPY_UMOUNT_SCRIPT=5
ERROR_CODE_RELOAD_RULES=6
ERROR_CODE_DAEMON_RELOAD=7

if test -z "$DEBIAN_EXTENSION_HOME"; then
 echo "Debian extension home path is empty!"
 exit $ERROR_CODE_SERVICE
fi

CODE=0

FILE_NAME="99-usb-mount.rules"

cp $DEBIAN_EXTENSION_HOME/util/mount/res/$FILE_NAME /etc/udev/rules.d/$FILE_NAME; CODE=$?
if test $CODE -ne 0; then
 echo "Copy mount rules error!"
 exit $ERROR_CODE_COPY_RULES
fi

FILE_NAME="usb-mount@.service"

cp $DEBIAN_EXTENSION_HOME/util/mount/res/$FILE_NAME /lib/systemd/system/$FILE_NAME; CODE=$?
if test $CODE -ne 0; then
 echo "Copy mount service error!"
 exit $ERROR_CODE_COPY_SERVICE
fi

FILE_NAME="usb_mount.sh"

cp $DEBIAN_EXTENSION_HOME/util/mount/$FILE_NAME /usr/local/bin/$FILE_NAME; CODE=$?
if test $CODE -ne 0; then
 echo "Copy mount script error!"
 exit $ERROR_CODE_COPY_MOUNT_SCRIPT
fi

FILE_NAME="usb_umount_auto.sh"

cp $DEBIAN_EXTENSION_HOME/util/mount/$FILE_NAME /usr/local/bin/$FILE_NAME; CODE=$?
if test $CODE -ne 0; then
 echo "Copy umount script error!"
 exit $ERROR_CODE_COPY_UMOUNT_SCRIPT
fi

udevadm control --reload-rules; CODE=$?
if test $CODE -ne 0; then
 echo "Reload rules error!"
 exit $ERROR_CODE_RELOAD_RULES
fi

/usr/bin/systemctl daemon-reload; CODE=$?
if test $CODE -ne 0; then
 echo "Daemon reload error!"
 exit $ERROR_CODE_DAEMON_RELOAD
fi

echo "install mount service success"

exit 0
