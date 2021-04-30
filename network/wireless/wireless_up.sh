#!/bin/bash

echo "wireless up..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_SERVICE=11
ERROR_CODE_EMPTY_NETWORK_INTERFACE_NAME=2
ERROR_CODE_EMPTY_SSID=3
ERROR_CODE_NETWORK_INTERFACE_STATE=4
ERROR_CODE_NETWORK_INTERFACE_UP=50
ERROR_CODE_ACCESS_POINT_CONNECT=60
ERROR_CODE_DHCLIENT=70

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be non-empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi

ARGUMENT_COUNT_EXPECTED=2
if test $# -ne $ARGUMENT_COUNT_EXPECTED; then
    echo "Script needs for $ARGUMENT_COUNT_EXPECTED arguments but actual $#"
    exit $ERROR_CODE_SERVICE
fi

NI_NAME=$1
SSID=$2

if test -z $NI_NAME; then
    echo "Network interface name must be not empty!"
    exit $ERROR_CODE_EMPTY_NETWORK_INTERFACE_NAME
fi
if test -z $SSID; then
    echo "SSID must be not empty!"
    exit $ERROR_CODE_EMPTY_SSID
fi

NI_STATE_UP=0x1003
NI_STATE_DOWN=0x1002
NI_STATE=$(cat /sys/class/net/$NI_NAME/flags)

CODE=0
case "$NI_STATE" in
 "$NI_STATE_UP")
  echo "Network interface state already up..."
 ;;
 "$NI_STATE_DOWN")
  /usr/bin/ip link set $NI_NAME up; CODE=$?
  if test $CODE -ne 0; then
   echo "Network interface up error $CODE!"
   exit $ERROR_CODE_NETWORK_INTERFACE_UP
  fi
 ;;
 *)
  echo "Network interface state expected \"$NI_STATE_UP\" or \"$NI_STATE_DOWN\" but actual \"$NI_STATE\"!"
  exit $ERROR_CODE_NETWORK_INTERFACE_STATE
 ;;
esac

#DRIVER=wext
DRIVER=nl80211
/usr/sbin/wpa_supplicant \
    -B \
    -D $DRIVER \
    -i $NI_NAME \
    -c "/etc/wpa_supplicant.$SSID.conf"
if test $? -ne 0; then
  echo "Connect to access point \"$SSID\" error!"
 exit $ERROR_CODE_ACCESS_POINT_CONNECT
fi

/usr/sbin/dhclient $NI_NAME; CODE=$?
if test $CODE -ne 0; then
 echo "dhclient error $CODE!"
 exit $ERROR_CODE_DHCLIENT
fi

echo "wireless $NI_NAME/$SSID up success."

exit 0
