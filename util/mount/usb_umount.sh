#!/bin/bash

echo "Umount..."

ERROR_CODE_SERVICE=1
ERROR_CODE_DEVICE_EMPTY=2
ERROR_CODE_MOUNTPOINT_EMPTY=32
ERROR_CODE_MOUNTPOINT_EXISTS=33
ERROR_CODE_UMOUNT=4

CODE=0

if test $# -ne 1; then
 echo "Script needs for 1 arguments but actual $#!"
 exit $ERROR_CODE_SERVICE
fi

DEVICE=$1

if test -z "$DEVICE"; then
 echo "Device is empty!"
 exit $ERROR_CODE_DEVICE_EMPTY
fi

MOUNTPOINT="${DEVICE}.m"
if test -z "$MOUNTPOINT"; then
 echo "Mount point \"$MOUNTPOINT\" of \"$DEVICE\" is empty!"
 exit $ERROR_CODE_MOUNTPOINT_EMPTY
fi
if test -d "$MOUNTPOINT"; then
 echo "Mount point \"$MOUNTPOINT\" of \"$DEVICE\" exists..."
else
 echo "Mount point \"$MOUNTPOINT\" of \"$DEVICE\" does not exist!"
 exit $ERROR_CODE_MOUNTPOINT_EXISTS
fi

/usr/bin/umount $MOUNTPOINT; CODE=$?
if test $CODE -eq 32; then
 /usr/bin/umount -l $MOUNTPOINT; CODE=$?
fi
if test $CODE -ne 0; then
 echo "Umount \"$DEVICE\" from \"$MOUNTPOINT\" error $CODE!"
 exit $ERROR_CODE_UMOUNT
fi

rm -rf $MOUNTPOINT

echo "Umount \"$DEVICE\" from \"$MOUNTPOINT\" success."

exit 0
