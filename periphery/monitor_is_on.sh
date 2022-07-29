#!/bin/bash

RESULT=$(/usr/bin/xset q)
if test $? -ne 0; then
 echo "Monitor status error!"; exit 11
elif test -z "$RESULT"; then
 echo "Monitor status empty!"; exit 12
fi

RESULT=$(grep "Monitor" <<< "$RESULT")
if test -z "$RESULT"; then
 echo "Monitor filter empty!"; exit 13
fi

ARRAY=($RESULT)
if test ${#ARRAY[@]} -ne 3; then
 echo "Monitor status format error!"; exit 14
fi
RESULT="${ARRAY[2]}"
if test -z "$RESULT"; then
 echo "Monitor filter empty!"; exit 15
fi

case "$RESULT" in
 "On") echo "true"; exit 0;;
 "Off") echo "false"; exit 0;;
 *) exit 16;;
esac

exit 0
