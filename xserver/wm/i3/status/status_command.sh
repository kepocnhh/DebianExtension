#!/bin/bash

ERROR_CODE_SERVICE=1

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

echo '{"version":1}'
echo '['
echo '[]'

while :; do
 TIME=$(date +"%Y/%m/%d %H:%M:%S")
 RESULT="{\"full_text\":\"$TIME\"}"

 MOUNT=$($DEBIAN_EXTENSION_HOME/util/mount/get_mount_by_device.sh)
 [ $? -eq 0 ] && RESULT="{\"full_text\":\"$MOUNT\"},$RESULT"

 echo ",[$RESULT]"
done

exit 0
