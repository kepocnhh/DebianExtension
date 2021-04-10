#!/bin/bash

ERROR_CODE_SERVICE=1
ERROR_CODE_ARGUMENT=100
ERROR_CODE_ARGUMENT_EMPTY=101
ERROR_CODE_ARGUMENT_NUMBER=102
ERROR_CODE_DISPLAY=10
ERROR_CODE_SCREEN_SAVER_STATE=20
ERROR_CODE_SCREEN_SAVER_TIME_IDLE_EMPTY=21
ERROR_CODE_SCREEN_SAVER_TIME_IDLE_NUMBER=22
ERROR_CODE_MEDIA_IS_PLAYING=30
ERROR_CODE_SCREEN_SAVER_RESET=40
ERROR_CODE_MONITOR_IS_ON=50
ERROR_CODE_MONITOR_OFF=51
ERROR_CODE_SCREEN_LOCK_UNEXPECTED=60
ERROR_CODE_SCREEN_LOCK_WM=61
ERROR_CODE_SUSPEND=70

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
if [[ "$TIME_SCREEN_OFF" =~ \D ]]; then
 echo "Time screen off number error!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_NUMBER
fi

TIME_SCREEN_LOCK=$2
if test -z "$TIME_SCREEN_LOCK"; then
 echo "Time screen lock empty!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_EMPTY
fi
if [[ "$TIME_SCREEN_LOCK" =~ \D ]]; then
 echo "Time screen lock number error!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_NUMBER
fi

TIME_SUSPEND=$3
if test -z "$TIME_SUSPEND"; then
 echo "Time suspend empty!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_EMPTY
fi
if [[ "$TIME_SUSPEND" =~ \D ]]; then
 echo "Time suspend number error!" >> $LOG_PATH
 exit $ERROR_CODE_ARGUMENT_NUMBER
fi

LOG_PATH="/tmp/on_idle.log"

if test -z "$DISPLAY"; then
 echo -e "\non idle display empty!" >> $LOG_PATH
 exit $ERROR_CODE_DISPLAY
fi

CODE=0

TIME_IDLE=$(/usr/bin/xssstate -i); CODE=$?
if test $CODE -ne 0; then
 echo "Screensaver state error $CODE!" >> $LOG_PATH
 exit $ERROR_CODE_SCREEN_SAVER_STATE
fi
if test -z "$TIME_IDLE"; then
 echo "Screensaver time idle empty!" >> $LOG_PATH
 exit $ERROR_CODE_SCREEN_SAVER_TIME_IDLE_EMPTY
fi
if [[ "$TIME_IDLE" =~ \D ]]; then
 echo "Screensaver time idle number error!" >> $LOG_PATH
 exit $ERROR_CODE_SCREEN_SAVER_TIME_IDLE_NUMBER
fi

[[ $TIME_IDLE -lt $((TIME_SCREEN_OFF/2)) ]] && exit 0

RESULT=$($DEBIAN_EXTENSION_HOME/media/media_is_palying.sh); CODE=$?
if test $CODE -ne 0; then
 echo "Media is playing error $CODE!" >> $LOG_PATH
 exit $ERROR_CODE_MEDIA_IS_PLAYING
fi
if test "$RESULT" == "true"; then
 /usr/bin/xset s reset; CODE=$?
 if test $CODE -ne 0; then
  echo "Screensaver reset error $CODE!" >> $LOG_PATH
  exit $ERROR_CODE_SCREEN_SAVER_RESET
 fi
 exit 0
fi

[[ $TIME_IDLE -lt $TIME_SCREEN_OFF ]] && exit 0

RESULT=$($DEBIAN_EXTENSION_HOME/periphery/monitor_is_on.sh); CODE=$?
if test $CODE -ne 0; then
 echo "Monitor is on error $CODE!" >> $LOG_PATH
 exit $ERROR_CODE_MONITOR_IS_ON
fi
if test "$RESULT" == "true"; then
 /usr/bin/xset dpms force off; CODE=$?
 if test $CODE -ne 0; then
  echo "Monitor off error $CODE!" >> $LOG_PATH
  exit $ERROR_CODE_MONITOR_OFF
 fi
 exit 0
fi

[[ $TIME_IDLE -lt $TIME_SCREEN_LOCK ]] && exit 0

RESULT=$(/usr/bin/pidof i3lock); CODE=$?
if test -z "$RESULT"; then
 if test $CODE -ne 1; then
  echo -e "pidof undefided behaviour\n code: $CODE" >> $LOG_PATH
  exit $ERROR_CODE_SCREEN_LOCK_UNEXPECTED
 fi
 COLOR_BG="#000000"
 /usr/bin/i3lock --color="$COLOR_BG"; CODE=$?
 if test $CODE -ne 0; then
  echo -e "pidof undefided behaviour\n code: $CODE" >> $LOG_PATH
  exit $ERROR_CODE_SCREEN_LOCK_WM
 fi
 exit 0
else
 if test $CODE -ne 0; then
  echo -e "pidof undefided behaviour\n code: $CODE\n result: \"$RESULT\"" >> $LOG_PATH
  exit $ERROR_CODE_SCREEN_LOCK_UNEXPECTED
 fi
fi

[[ $TIME_IDLE -lt $TIME_SUSPEND ]] && exit 0

sudo /usr/bin/systemctl suspend; CODE=$?
if test $CODE -ne 0; then
 echo "Suspend error $CODE!" >> $LOG_PATH
 exit $ERROR_CODE_SUSPEND
fi

/usr/bin/xset s reset; CODE=$?
if test $CODE -ne 0; then
 echo "Screensaver reset error $CODE!" >> $LOG_PATH
 exit $ERROR_CODE_SCREEN_SAVER_RESET
fi

exit 0
