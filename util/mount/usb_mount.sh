#!/bin/bash

echo "mount..."

ERROR_CODE_SERVICE=1
ERROR_CODE_EMPTY_DEVICE_NAME=2
ERROR_CODE_DEVICE_EXISTS=3
ERROR_CODE_MOUNT_DIR_EXISTS=41
ERROR_CODE_MOUNT_DIR_EMPTY=42
ERROR_CODE_MOUNT_CHANGE_OWNER=43
ERROR_CODE_MOUNT=5

CODE=0

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
	echo "Device \"$DEVICE_NAME\" exists..."
else
    echo "Device \"$DEVICE_NAME\" must be exists!"
    exit $ERROR_CODE_DEVICE_EXISTS
fi

MOUNT_PATH="/mnt/dev/$DEVICE_NAME"

if test -d $MOUNT_PATH; then
# if [ "$(ls $MOUNT_PATH)" ]; then
#  echo "Mount dir \"$DEVICE_NAME\" must be empty!"
#  exit $ERROR_CODE_MOUNT_DIR_EMPTY
# fi
 echo "Mount dir \"$DEVICE_NAME\" exists!"
 exit $ERROR_CODE_MOUNT_DIR_EXISTS
else
 mkdir -p $MOUNT_PATH
 chown root:users $MOUNT_PATH || CODE=$?
 if test $CODE -ne 0; then
  echo "Mount \"$DEVICE_NAME\" change owner error $CODE!"
  exit $ERROR_CODE_MOUNT_CHANGE_OWNER
 fi
fi

/usr/bin/mount -o umask=0 $DEVICE_PATH $MOUNT_PATH || CODE=$?
if test $CODE -ne 0; then
 echo "Mount \"$DEVICE_NAME\" error $CODE!"
 exit $ERROR_CODE_MOUNT
fi

exit 0
