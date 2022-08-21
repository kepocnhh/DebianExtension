#!/bin/bash

tmp=$(ls /dev/sd* 2> /dev/null | grep -E "^/dev/sd[a-z][1-9]$")
if test $? -ne 0; then
 echo "Device does not exist!"; exit 11
elif test -z "$tmp"; then
 echo "Device is empty!"; exit 12
fi

ARRAY=(${tmp//$'\n'/ })

RESULT=""
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
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
 echo "Result is empty!"; exit 21
fi

echo "$RESULT"

exit 0
