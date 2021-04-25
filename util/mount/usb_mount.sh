#!/bin/bash

echo "mount..."

ERROR_CODE_SERVICE=1
ERROR_CODE_DEVICE_EMPTY=21
ERROR_CODE_DEVICE_EXISTS=22
ERROR_CODE_MOUNTPOINT_EXISTS=31
ERROR_CODE_MOUNTPOINT_CHANGE_OWNER=32
ERROR_CODE_MOUNT=5

CODE=0


if test $# -ne 1; then
 echo "Script needs for 1 arguments but actual $#"
 exit $ERROR_CODE_SERVICE
fi

DEVICE=$1

if test -z "$DEVICE"; then
 echo "Device is empty!"
 exit $ERROR_CODE_DEVICE_EMPTY
fi
if test -e "$DEVICE"; then
 echo "Device \"$DEVICE_NAME\" exists..."
else
 echo "Device \"$DEVICE_NAME\" does not exist!"
 exit $ERROR_CODE_DEVICE_EXISTS
fi

MOUNTPOINT="${DEVICE}.m"
if test -d "$MOUNTPOINT"; then
 echo "Mount point \"$DEVICE\" exists!"
 exit $ERROR_CODE_MOUNTPOINT_EXISTS
else
 /usr/bin/mkdir -p $MOUNTPOINT
 /usr/bin/chown root:users $MOUNTPOINT; CODE=$?
 if test $CODE -ne 0; then
  echo "Mount \"$DEVICE\" change owner error $CODE!"
  exit $ERROR_CODE_MOUNTPOINT_CHANGE_OWNER
 fi
fi

/usr/bin/mount -o umask=0 $DEVICE $MOUNTPOINT; CODE=$?
if test $CODE -ne 0; then
 echo "Mount \"$DEVICE\" error $CODE!"
 exit $ERROR_CODE_MOUNT
fi

echo "mount \"$DEVICE\" success"

exit 0
