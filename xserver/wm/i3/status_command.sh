#!/bin/bash

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

COLOR_GRAY='#888888'
COLOR_RED='#d32f2f'
COLOR_GREEN='#43a047'
COLOR_BLUE='#1976d2'
COLOR_WHITE='#ffffff'
echo '{"version":1,"click_events":true}'
echo '['
echo '[]'

(while :; do
 TIME=$(date +"%Y/%m/%d %H:%M:%S")
 RESULT="{\"full_text\":\"$TIME\"}"

 CODE=0
 STATUS=$($DEBIAN_EXTENSION_HOME/core/network/bluetooth/is_powered.sh "$BT_MAC_CONTROLLER")
 if [ $CODE -eq 0 ] && [ "$STATUS" == yes ]; then
  STATUS=$($DEBIAN_EXTENSION_HOME/core/network/bluetooth/is_connected.sh "$BT_MAC_SPEAKERS")
  if [ $CODE -eq 0 ] && [ "$STATUS" == yes ]; then
   RESULT="{\"name\":\"speakers_on\",\"full_text\":\"S\",\"color\":\"$COLOR_WHITE\"},$RESULT"
  elif [ $CODE -eq 0 ] && [ "$STATUS" == no ]; then
   RESULT="{\"name\":\"speakers_off\",\"full_text\":\"S\",\"color\":\"$COLOR_GRAY\"},$RESULT"
  else
   RESULT="{\"full_text\":\"S\",\"color\":\"$COLOR_RED\"},$RESULT"
  fi
 elif [ $CODE -eq 0 ] && [ "$STATUS" == no ]; then
  RESULT="{\"name\":\"bt_off\",\"full_text\":\"B\",\"color\":\"$COLOR_GRAY\"},$RESULT"
 else
  RESULT="{\"full_text\":\"B\",\"color\":\"$COLOR_RED\"},$RESULT"
 fi

 CODE=0
 STATUS=$($DEBIAN_EXTENSION_HOME/core/network/wireless/is_up.sh "$NI_WIRELESS")
 if [ $CODE -eq 0 ] && [ "$STATUS" == up ]; then
  RESULT="{\"full_text\":\"W\",\"color\":\"$COLOR_WHITE\"},$RESULT"
 elif [ $CODE -eq 0 ] && [ "$STATUS" == down ]; then
  RESULT="{\"full_text\":\"W\",\"color\":\"$COLOR_GRAY\"},$RESULT"
 else
  RESULT="{\"full_text\":\"W\",\"color\":\"$COLOR_RED\"},$RESULT"
 fi

# SSID=$($DEBIAN_EXTENSION_HOME/core/network/wireless/get_wireless_ssid.sh $WF_NI_MAIN)
# [ $? -eq 0 ] && RESULT="{\"full_text\":\"$WF_NI_MAIN/$SSID\",\"color\":\"$COLOR_GREEN\"},$RESULT"

 MOUNT=$($DEBIAN_EXTENSION_HOME/core/util/mount/get_mount_by_device.sh)
 [ $? -eq 0 ] && RESULT="{\"full_text\":\"$MOUNT\"},$RESULT"

 echo ",[$RESULT]"
done) &

while read it; do
 case "$(echo $it | jq -r .name)" in
  bt_off) if test "$($DEBIAN_EXTENSION_HOME/core/network/bluetooth/is_powered.sh "$BT_MAC_CONTROLLER")" == no; then
   /usr/bin/bluetoothctl power on > /dev/null &
  fi;;
  speakers_off) if test "$($DEBIAN_EXTENSION_HOME/core/network/bluetooth/is_connected.sh "$BT_MAC_SPEAKERS")" == no; then
   /usr/bin/bluetoothctl connect $BT_MAC_SPEAKERS > /tmp/bt_connect.log &
  fi;;
  speakers_on) if test "$($DEBIAN_EXTENSION_HOME/core/network/bluetooth/is_connected.sh "$BT_MAC_SPEAKERS")" == yes; then
   /usr/bin/bluetoothctl disconnect $BT_MAC_SPEAKERS > /tmp/bt_disconnect.log &
  fi;;
 esac
done

exit 0
