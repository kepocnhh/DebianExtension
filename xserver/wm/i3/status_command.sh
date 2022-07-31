#!/bin/bash

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

COLOR_GREEN='#66BB6A'
echo '{"version":1}'
echo '['
echo '[]'

while :; do
 TIME=$(date +"%Y/%m/%d %H:%M:%S")
 RESULT="{\"full_text\":\"$TIME\"}"

# SSID=$($DEBIAN_EXTENSION_HOME/core/network/wireless/get_wireless_ssid.sh $WF_NI_MAIN)
# [ $? -eq 0 ] && RESULT="{\"full_text\":\"$WF_NI_MAIN/$SSID\",\"color\":\"$COLOR_GREEN\"},$RESULT"

 MOUNT=$($DEBIAN_EXTENSION_HOME/core/util/mount/get_mount_by_device.sh)
 [ $? -eq 0 ] && RESULT="{\"full_text\":\"$MOUNT\"},$RESULT"

 echo ",[$RESULT]"
done

exit 0
