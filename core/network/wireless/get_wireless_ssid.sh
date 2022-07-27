#!/bin/bash

ERROR_CODE_SERVICE=11
ERROR_CODE_NETWORK_INTERFACE_NAME_EMPTY=21
ERROR_CODE_NETWORK_INTERFACE_DOWN=41
ERROR_CODE_NETWORK_INTERFACE_STATE=42
ERROR_CODE_NETWORK_INTERFACE_INFO=31
ERROR_CODE_NETWORK_INTERFACE_INFO_EMPTY=32
ERROR_CODE_NETWORK_INTERFACE_INFO_FILTER=33
ERROR_CODE_NETWORK_INTERFACE_INFO_FORMAT=34
ERROR_CODE_SSID_EMPTY=51

ARGUMENT_COUNT_EXPECTED=1
if test $# -ne $ARGUMENT_COUNT_EXPECTED; then
 echo "Script needs for $ARGUMENT_COUNT_EXPECTED arguments but actual $#"
 exit $ERROR_CODE_SERVICE
fi

NI_NAME=$1

if test -z $NI_NAME; then
    echo "Network interface name must be not empty!"
    exit $ERROR_CODE_EMPTY_NETWORK_INTERFACE_NAME
fi

NI_STATE_UP=0x1003
NI_STATE_DOWN=0x1002
NI_STATE=$(cat /sys/class/net/$NI_NAME/flags)
case "$NI_STATE" in
 "$NI_STATE_UP");;
 "$NI_STATE_DOWN")
  echo "Network interface down!"
  exit $ERROR_CODE_NETWORK_INTERFACE_DOWN
 ;;
 *)
  echo "Network interface state expected \"$NI_STATE_UP\" or \"$NI_STATE_DOWN\" but actual \"$NI_STATE\"!"
  exit $ERROR_CODE_NETWORK_INTERFACE_STATE
 ;;
esac

CODE=0
RESULT=$(/usr/sbin/iw dev $NI_NAME info); CODE=$?
if test $CODE -ne 0; then
 echo "Network interface $NI_NAME info error $CODE!"
 exit $ERROR_CODE_NETWORK_INTERFACE_INFO
fi
if test -z "$RESULT"; then
 echo "Network interface $NI_NAME info empty!"
 exit $ERROR_CODE_NETWORK_INTERFACE_INFO_EMPTY
fi

RESULT=$(grep "ssid" <<< "$RESULT")
if test -z "$RESULT"; then
 echo "Network interface $NI_NAME info filter empty!"
 exit $ERROR_CODE_NETWORK_INTERFACE_INFO_FILTER
fi

ARRAY=($RESULT)
if test ${#ARRAY[@]} -ne 2; then
 echo "Network interface $NI_NAME info format error!"
 exit $ERROR_CODE_NETWORK_INTERFACE_INFO_FORMAT
fi
RESULT="${ARRAY[1]}"
if test -z "$RESULT"; then
 echo "SSID empty!"
 exit $ERROR_CODE_SSID_EMPTY
fi

echo "$RESULT"

exit 0
