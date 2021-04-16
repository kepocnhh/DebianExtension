#!/bin/bash

ERROR_CODE_DEVICE_EXIST=11
ERROR_CODE_DEVICE_EMPTY=21
ERROR_CODE_RESULT_EMPTY=31
ERROR_CODE_MOUNTS_EMPTY=41

tmp=$(ls /dev/sd*)
if test $? -ne 0; then
 echo "Device must exist!"
 exit $ERROR_CODE_DEVICE_EXIST
fi

tmp=$(grep -E "sd[a-z][0-9]" <<< $tmp)
if test -z "$tmp"; then
 echo "Device empty!"
 exit $ERROR_CODE_DEVICE_EMPTY
fi

array=(${tmp//$'\n'/ })
SIZE=${#array[@]}

MOUNTS=$(cat /proc/mounts)
if test -z "$MOUNTS"; then
 echo "Mounts empty!"
 exit $ERROR_CODE_MOUNTS_EMPTY
fi

RESULT=""
for ((i = 0; i < SIZE; i++)); do
 DEVICE="${array[$i]}"
 [[ $? -ne 0 ]] && continue
 INFO=$(grep "$DEVICE" <<< "$MOUNTS")
 if test -n "$INFO"; then
  tmp=($INFO)
  RESULT="${tmp[1]} $RESULT"
 fi
done

if test -z "$RESULT"; then
 echo "Result empty!"
 exit $ERROR_CODE_RESULT_EMPTY
fi

echo "$RESULT"

exit 0
