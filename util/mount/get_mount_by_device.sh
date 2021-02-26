#!/bin/bash

ERROR_CODE_DEVICE_EXIST=11
ERROR_CODE_DEVICE_EMPTY=21
ERROR_CODE_RESULT_EMPTY=31

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
RESULT=""
for ((i = 0; i < SIZE; i++)); do
 DEVICE="${array[$i]}"
 INFO=$(cat /proc/mounts)
 [[ $? -ne 0 ]] && continue
 INFO=$(grep "$DEVICE" <<< "$INFO")
 if [ ! -z "$INFO" ]; then
  tmp=($INFO)
  PATH=${m[1]}
  RESULT="$PATH $RESULT"
 fi
done

if test -z "$RESULT"; then
 echo "Result empty!"
 exit $ERROR_CODE_RESULT_EMPTY
fi

echo "$RESULT"

exit 0
