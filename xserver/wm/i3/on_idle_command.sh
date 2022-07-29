#!/bin/bash

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

if test $# -ne 3; then
  echo "Script needs for 3 arguments but actual $#!"; exit 12
fi

TIME_SCREEN_OFF=$1
TIME_SCREEN_LOCK=$2
TIME_SUSPEND=$3

for it in TIME_SCREEN_OFF TIME_SCREEN_LOCK TIME_SUSPEND; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

LOG_PATH="/tmp/on_idle.log"

if test "$TIME_SCREEN_OFF" =~ \D; then
 echo "Time screen off number error!" >> $LOG_PATH; exit 14
elif test "$TIME_SCREEN_LOCK" =~ \D; then
 echo "Time screen lock number error!" >> $LOG_PATH; exit 15
elif test "$TIME_SUSPEND" =~ \D; then
 echo "Time suspend number error!" >> $LOG_PATH; exit 16
fi

if test -z "$DISPLAY"; then
 echo -e "\non idle command display empty!" >> $LOG_PATH; exit 17
fi

TIME_OUT=10

TIME_START=$(date +%s)
while :
do
 TIME_NOW=$(date +%s)
 tmp=$((TIME_NOW-TIME_START))
 if test $tmp -gt $TIME_OUT; then
  echo "Timeout error!" >> $LOG_PATH; exit 21
 fi
 tmp=$(/usr/bin/xdpyinfo | grep version)
 [[ $? -ne 0 ]] && continue
 if test -z "$tmp"; then
  continue
 else
  echo -e "xdpyinfo version:\n$tmp" >> $LOG_PATH; break
 fi
done

TIME_STEP=2

while :
do
 if test -z "$DISPLAY"; then
  echo "on idle command display empty!" >> $LOG_PATH; exit 22
 fi
 CODE=0
 $DEBIAN_EXTENSION_HOME/xserver/wm/i3/on_idle.sh $TIME_SCREEN_OFF $TIME_SCREEN_LOCK $TIME_SUSPEND; CODE=$?
 if test $CODE -ne 0; then
  echo "on idle script error $CODE!" >> $LOG_PATH; exit 23
 fi
 sleep $TIME_STEP
done

exit 0
