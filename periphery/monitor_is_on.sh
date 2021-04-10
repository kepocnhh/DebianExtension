#!/bin/bash

ERROR_CODE_STATUS=10
ERROR_CODE_STATUS_EMPTY=11
ERROR_CODE_STATUS_FILTER=12
ERROR_CODE_STATUS_FORMAT=13
ERROR_CODE_STATUS_UNEXPECTED=14

CODE=0
RESULT=$(/usr/bin/xset q); CODE=$?
if test $CODE -ne 0; then
 echo "Monitor status error $CODE!"
 exit $ERROR_CODE_STATUS
fi
if test -z "$RESULT"; then
 echo "Monitor status empty!"
 exit $ERROR_CODE_STATUS_EMPTY
fi

RESULT=$(grep "Monitor" <<< "$RESULT")
if test -z "$RESULT"; then
 echo "Monitor filter empty!"
 exit $ERROR_CODE_STATUS_FILTER
fi

ARRAY=($RESULT)
if test ${#ARRAY[@]} -ne 3; then
 echo "Monitor status format error!"
 exit $ERROR_CODE_STATUS_FORMAT
fi
RESULT="${ARRAY[2]}"
if test -z "$RESULT"; then
 echo "Monitor filter empty!"
 exit $ERROR_CODE_STATUS_EMPTY
fi

case "$RESULT" in
 "On")
  echo "true"
  exit 0
 ;;
 "Off")
  echo "false"
  exit 0
 ;;
 *) exit $ERROR_CODE_STATUS_UNEXPECTED;;
esac

exit 0
