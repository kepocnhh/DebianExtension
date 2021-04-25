#!/bin/bash

echo "umount auto..."

ERROR_CODE_SERVICE=1
ERROR_CODE_EMPTY_DEVICE_NAME=2
ERROR_CODE_MOUNTPOINT_GET=31
ERROR_CODE_MOUNTPOINT_EMPTY=32
ERROR_CODE_MOUNTPOINT_EXISTS=33
ERROR_CODE_UMOUNT=4

CODE=0

if test $# -ne 1; then
 echo "Script needs for 1 arguments but actual $#"
 exit $ERROR_CODE_SERVICE
fi

DEVICE_NAME=$1

if test -z "$DEVICE_NAME"; then
    echo "Device name must be not empty!"
    exit $ERROR_CODE_EMPTY_DEVICE_NAME
fi

MOUNTPOINT=$(/usr/bin/lsblk -nb "$DEVICE" -o MOUNTPOINT); CODE=$?
if test $CODE -ne 0; then
 echo "Get mount point \"$DEVICE_NAME\" error $CODE!"
 exit $ERROR_CODE_MOUNTPOINT_GET
fi
if test -z "$MOUNTPOINT"; then
 echo "Mount point \"$DEVICE_NAME\" is empty!"
 exit $ERROR_CODE_MOUNTPOINT_EMPTY
fi
if test -d "$MOUNTPOINT"; then
 echo "Mount point \"$DEVICE_NAME\" exists..."
else
 echo "Mount point \"$DEVICE_NAME\" does not exist!"
 exit $ERROR_CODE_MOUNTPOINT_EXISTS
fi

/usr/bin/umount $MOUNTPOINT; CODE=$?
if test $CODE -ne 0; then
 echo "Umount \"$DEVICE_NAME\" error $CODE!"
 exit $ERROR_CODE_UMOUNT
fi

rm -rf $MOUNTPOINT

echo "umount auto success"

exit 0
