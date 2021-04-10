#!/bin/bash

ERROR_CODE_SERVICE=1
ERROR_CODE_ARGUMENT=100
ERROR_CODE_ARGUMENT_EMPTY=101
ERROR_CODE_ARGUMENT_NUMBER=102
ERROR_CODE_DISPLAY=10
ERROR_CODE_TIME_OUT=20
ERROR_CODE_SCRIPT=30

if test -z "$DEBIAN_EXTENSION_HOME"; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

ARGUMENT_COUNT_EXPECTED=3
ARGUMENT_COUNT_ACTUAL=$#
if test $ARGUMENT_COUNT_ACTUAL -ne $ARGUMENT_COUNT_EXPECTED; then
    echo "Argument count expected $ARGUMENT_COUNT_EXPECTED but actual $ARGUMENT_COUNT_ACTUAL!"
    exit $ERROR_CODE_ARGUMENT
fi

TIME_SCREEN_OFF=$1
if test -z "$TIME_SCREEN_OFF"; then
 echo "Time screen off empty!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_EMPTY
fi
if test "$TIME_SCREEN_OFF" =~ \D; then
 echo "Time screen off number error!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_NUMBER
fi

TIME_SCREEN_LOCK=$2
if test -z "$TIME_SCREEN_LOCK"; then
 echo "Time screen lock empty!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_EMPTY
fi
if test "$TIME_SCREEN_LOCK" =~ \D; then
 echo "Time screen lock number error!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_NUMBER
fi

TIME_SUSPEND=$3
if test -z "$TIME_SUSPEND"; then
 echo "Time suspend empty!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_EMPTY
fi
if test "$TIME_SUSPEND" =~ \D; then
 echo "Time suspend number error!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_NUMBER
fi

LOG_PATH="/tmp/on_idle.log"

if test -z "$DISPLAY"; then
 echo -e "\non idle command display empty!" >> $LOG_PATH
 exit $ERROR_CODE_DISPLAY
fi

TIME_OUT=10

TIME_START=$(date +%s)
while :
do
 TIME_NOW=$(date +%s)
 tmp=$((TIME_NOW-TIME_START))
 if test $tmp -gt $TIME_OUT; then
  echo "Timeout error!" >> $LOG_PATH
  exit $ERROR_CODE_TIME_OUT
 fi
 tmp=$(/usr/bin/xdpyinfo | grep version)
 [[ $? -ne 0 ]] && continue
 if test -z "$tmp"; then
  continue
 else
  echo -e "xdpyinfo version:\n$tmp" >> $LOG_PATH
  break
 fi
done

TIME_STEP=2

while :
do
 if test -z "$DISPLAY"; then
  echo "on idle command display empty!" >> $LOG_PATH
  exit $ERROR_CODE_DISPLAY
 fi
 CODE=0
 $DEBIAN_EXTENSION_HOME/xserver/wm/i3/on_idle.sh $TIME_SCREEN_OFF $TIME_SCREEN_LOCK $TIME_SUSPEND; CODE=$?
 if test $CODE -ne 0; then
  echo "on idle script error $CODE!" >> $LOG_PATH
  exit $ERROR_CODE_SCRIPT
 fi
 sleep $TIME_STEP
done

exit 0
