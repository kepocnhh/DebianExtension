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

TIME_IDLE=$(/usr/bin/xssstate -i)
if test $? -ne 0; then
 echo "Screensaver state error!" >> $LOG_PATH; exit 21
elif test -z "$TIME_IDLE"; then
 echo "Screensaver time idle empty!" >> $LOG_PATH; exit 22
elif [[ "$TIME_IDLE" =~ \D ]]; then
 echo "Screensaver time idle number error!" >> $LOG_PATH; exit 23
fi

[[ $TIME_IDLE -lt $((TIME_SCREEN_OFF/2)) ]] && exit 0

RESULT=$($DEBIAN_EXTENSION_HOME/media/media_is_playing.sh)
if test $? -ne 0; then
 echo "Media is playing error!" >> $LOG_PATH; exit 31
elif test "$RESULT" == "true"; then
 /usr/bin/xset s reset
 if test $? -ne 0; then
  echo "Screensaver reset error!" >> $LOG_PATH; exit 32
 fi
 exit 0
fi

[[ $TIME_IDLE -lt $TIME_SCREEN_OFF ]] && exit 0

RESULT=$($DEBIAN_EXTENSION_HOME/periphery/monitor_is_on.sh)
if test $? -ne 0; then
 echo "Monitor is on error!" >> $LOG_PATH; exit 41
fi
if test "$RESULT" == "true"; then
 /usr/bin/xset dpms force off
 if test $? -ne 0; then
  echo "Monitor off error!" >> $LOG_PATH; exit 42
 fi
 exit 0
fi

TIME_RESULT=$TIME_SCREEN_OFF
TIME_RESULT=$((TIME_RESULT+TIME_SCREEN_LOCK))
[[ $TIME_IDLE -lt $TIME_RESULT ]] && exit 0

RESULT=$(/usr/bin/pidof i3lock)
if test -z "$RESULT"; then
 if test $? -ne 1; then
  echo -e "pidof undefided behaviour!" >> $LOG_PATH; exit 51
 fi
 COLOR_BG="#000000"
 /usr/bin/i3lock --color="$COLOR_BG"
 if test $? -ne 0; then
  echo -e "pidof undefided behaviour!" >> $LOG_PATH; exit 52
 fi
 exit 0
else
 if test $? -ne 0; then
  echo -e "pidof undefided behaviour!\n result: \"$RESULT\"" >> $LOG_PATH; exit 53
 fi
fi

TIME_RESULT=$((TIME_RESULT+TIME_SUSPEND))
[[ $TIME_IDLE -lt $TIME_RESULT ]] && exit 0

sudo /usr/bin/systemctl suspend
if test $? -ne 0; then
 echo "Suspend error!" >> $LOG_PATH; exit 61
fi

/usr/bin/xset s reset
if test $? -ne 0; then
 echo "Screensaver reset error!" >> $LOG_PATH; exit 71
fi

exit 0
