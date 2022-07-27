#!/bin/bash

ERROR_CODE_DEVICE_EXIST=11
ERROR_CODE_DEVICE_EMPTY=21
ERROR_CODE_RESULT_EMPTY=31

tmp=$(ls /dev/sd* | grep -E "sd[a-z][0-9]")
if test $? -ne 0; then
 echo "Device must exist!"
 exit $ERROR_CODE_DEVICE_EXIST
fi
if test -z "$tmp"; then
 echo "Device empty!"
 exit $ERROR_CODE_DEVICE_EMPTY
fi

ARRAY=(${tmp//$'\n'/ })
SIZE=${#ARRAY[@]}

RESULT=""
for ((i = 0; i < SIZE; i++)); do
 DEVICE="${ARRAY[$i]}"
 MOUNTPOINT=$(/usr/bin/lsblk -nb "$DEVICE" -o MOUNTPOINT)
 [[ $? -ne 0 ]] && continue
 if test -n "$MOUNTPOINT"; then
  if test -z "$RESULT"; then
   RESULT="$MOUNTPOINT"
  else
   RESULT="$MOUNTPOINT $RESULT"
  fi
 fi
done

if test -z "$RESULT"; then
 echo "Result empty!"
 exit $ERROR_CODE_RESULT_EMPTY
fi

echo "$RESULT"

exit 0
