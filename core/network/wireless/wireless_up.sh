#!/bin/bash

if test $# -ne 2; then
  echo "Script needs for 2 arguments but actual $#!"; exit 11
fi

NI_NAME=$1
SSID=$2

for it in NI_NAME SSID; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

if [ ! -s "/etc/wpa_supplicant.${SSID}.conf" ]; then
  echo "WPA supplicant conf for ssid \"$SSID\" does not exist!"; exit 13
fi

NI_STATE_UP=0x1003
NI_STATE_DOWN=0x1002
NI_STATE=$(cat /sys/class/net/$NI_NAME/flags)

case "$NI_STATE" in
 "$NI_STATE_UP") echo "Network interface state already up...";;
 "$NI_STATE_DOWN")
  /usr/bin/ip link set $NI_NAME up
  if test $? -ne 0; then
   echo "Network interface \"$NI_NAME\" up error!"; exit 21
  fi
 ;;
 *)
  echo "Network interface state expected \"$NI_STATE_UP\" or \"$NI_STATE_DOWN\" but actual \"$NI_STATE\"!"; exit 22
 ;;
esac

# DRIVER=wext # legacy Linux wireless extensions ioctl-based interface
DRIVER=nl80211 # modern Linux nl80211/cfg80211 netlink-based interface
/usr/sbin/wpa_supplicant \
 -B \
 -D $DRIVER \
 -i $NI_NAME \
 -c "/etc/wpa_supplicant.${SSID}.conf"
if test $? -ne 0; then
 echo "Connect to access point \"$SSID\" error!"; exit 31
fi

/usr/sbin/dhclient $NI_NAME
if test $? -ne 0; then
 echo "dhclient error!"; exit 32
fi

exit 0
