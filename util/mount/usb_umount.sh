echo "umount..."

ERROR_CODE_SERVICE=1
ERROR_CODE_EMPTY_DEVICE_NAME=2
ERROR_CODE_DEVICE_EXISTS=3
ERROR_CODE_MOUNT_PATH_EXISTS=4
ERROR_CODE_UMOUNT=5

if test $# -ne 1; then
    echo "Script needs for 1 arguments but actual $#"
    exit $ERROR_CODE_SERVICE
fi

DEVICE_NAME=$1

if test -z $DEVICE_NAME; then
    echo "Device name must be not empty!"
    exit $ERROR_CODE_EMPTY_DEVICE_NAME
fi

DEVICE_PATH="/dev/$DEVICE_NAME"

if test -e $DEVICE_PATH; then
	# ignored
else
    echo "Device \"$DEVICE_NAME\" must be exists!"
    exit $ERROR_CODE_DEVICE_EXISTS
fi

MOUNT_PATH="/mnt/$DEVICE_NAME"

if test -d $MOUNT_PATH; then
    # ignored
else
    echo "Mount dir \"$DEVICE_NAME\" must be exists!"
    exit $ERROR_CODE_MOUNT_PATH_EXISTS
fi

STATUS=0

/usr/bin/umount $MOUNT_PATH || STATUS=$?
if test $STATUS -ne 0; then
    echo "Umount \"$DEVICE_NAME\" error!"
    exit $ERROR_CODE_UMOUNT
fi

rm -rf $MOUNT_PATH

exit 0
