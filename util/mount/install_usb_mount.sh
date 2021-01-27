echo "install mount..."

ERROR_CODE_SERVICE=1
ERROR_CODE_COPY_RULES=2
ERROR_CODE_COPY_SERVICE=3
ERROR_CODE_COPY_MOUNT_SCRIPT=4
ERROR_CODE_COPY_UMOUNT_SCRIPT=5
ERROR_CODE_RELOAD_RULES=6
ERROR_CODE_DAEMON_RELOAD=7

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

STATUS=0

RULES_NAME="99-usb-mount.rules"

cp $DEBIAN_EXTENSION_HOME/util/mount/res/$RULES_NAME /etc/udev/rules.d/$RULES_NAME || STATUS=$?
if test $STATUS -ne 0; then
    echo "Copy mount rules error!"
    exit $ERROR_CODE_COPY_RULES
fi

SERVICE_NAME="usb-mount@.service"

cp $DEBIAN_EXTENSION_HOME/util/mount/res/$SERVICE_NAME /lib/systemd/system/$SERVICE_NAME || STATUS=$?
if test $STATUS -ne 0; then
    echo "Copy mount service error!"
    exit $ERROR_CODE_COPY_SERVICE
fi

MOUNT_SCRIPT_NAME="usb_mount.sh"

cp $DEBIAN_EXTENSION_HOME/util/mount/$MOUNT_SCRIPT_NAME /usr/local/bin/$MOUNT_SCRIPT_NAME || STATUS=$?
if test $STATUS -ne 0; then
    echo "Copy mount script error!"
    exit $ERROR_CODE_COPY_MOUNT_SCRIPT
fi

UMOUNT_SCRIPT_NAME="usb_umount.sh"

cp $DEBIAN_EXTENSION_HOME/util/mount/$UMOUNT_SCRIPT_NAME /usr/local/bin/$UMOUNT_SCRIPT_NAME || STATUS=$?
if test $STATUS -ne 0; then
    echo "Copy umount script error!"
    exit $ERROR_CODE_COPY_UMOUNT_SCRIPT
fi

udevadm control --reload-rules || STATUS=$?
if test $STATUS -ne 0; then
    echo "Reload rules error!"
    exit $ERROR_CODE_RELOAD_RULES
fi

/usr/bin/systemctl daemon-reload || STATUS=$?
if test $STATUS -ne 0; then
    echo "Daemon reload error!"
    exit $ERROR_CODE_DAEMON_RELOAD
fi

exit 0
