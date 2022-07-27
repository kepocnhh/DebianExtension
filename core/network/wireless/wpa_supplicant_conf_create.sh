echo "create wpa_supplicant.conf..."

ERROR_CODE_SERVICE=1
ERROR_CODE_EMPTY_SSID=2
ERROR_CODE_EMPTY_PASSWORD=3
ERROR_CODE_WPA_PASSPHRASE=4
ERROR_CODE_MOVE_CONFIG=5

ARGUMENT_COUNT_EXPECTED=2
if test $# -ne $ARGUMENT_COUNT_EXPECTED; then
    echo "Script needs for $ARGUMENT_COUNT_EXPECTED arguments but actual $#"
    exit $ERROR_CODE_SERVICE
fi

SSID=$1
PASSWORD=$2

if test -z $SSID; then
    echo "SSID must be not empty!"
    exit $ERROR_CODE_EMPTY_SSID
fi
if test -z $PASSWORD; then
    echo "PASSWORD must be not empty!"
    exit $ERROR_CODE_EMPTY_PASSWORD
fi

TMP_FILE_PATH=/tmp/wpa_supplicant.tmp.conf

STATUS=0

/usr/bin/wpa_passphrase "$SSID" "$PASSWORD" >> "$TMP_FILE_PATH" || STATUS=$?
if test $STATUS -ne 0; then
	echo "create wpa_supplicant.conf error!"
	rm "$TMP_FILE_PATH"
    exit $ERROR_CODE_WPA_PASSPHRASE
fi

RESULT_FILE_PATH="/etc/wpa_supplicant.$SSID.conf"
mv "$TMP_FILE_PATH" "$RESULT_FILE_PATH" || STATUS=$?
if test $STATUS -ne 0; then
	echo "move wpa_supplicant.conf error!"
	rm "$TMP_FILE_PATH"
    exit $ERROR_CODE_MOVE_CONFIG
fi

echo "create \"$RESULT_FILE_PATH\" success."

exit 0
