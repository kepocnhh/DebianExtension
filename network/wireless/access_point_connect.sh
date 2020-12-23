echo "access point connect..."

ERROR_CODE_SERVICE=1
ERROR_CODE_EMPTY_NETWORK_INTERFACE_NAME=2
ERROR_CODE_EMPTY_SSID=3
ERROR_CODE_NETWORK_INTERFACE_STATE=4
ERROR_CODE_CONNECT=5

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

NI_STATE_EXPECTED=0x1003
NI_STATE=$(cat /sys/class/net/$NI_NAME/flags)

if test "$NI_STATE" != "$NI_STATE_EXPECTED"; then
    echo "Network interface state expected \"$NI_STATE_EXPECTED\" but actual \"$NI_STATE\"!"
    exit $ERROR_CODE_NETWORK_INTERFACE_STATE
fi

STATUS=0

/usr/sbin/wpa_supplicant \
    -B \
    -D wext \
    -i $NI_NAME \
    -c "/etc/wpa_supplicant.$SSID.conf" || STATUS=$?
if test $STATUS -ne 0; then
	echo "Connect to access point \"$SSID\" error!"
    exit $ERROR_CODE_CONNECT
fi

echo "Connect to access point \"$SSID\" success."

exit 0
