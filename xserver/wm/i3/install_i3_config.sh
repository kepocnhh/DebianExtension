echo "install i3 config..."

ERROR_CODE_SERVICE=1
ERROR_CODE_COPY_CONFIG_FILE=2
ERROR_CODE_COPY_CONFIG_STATUS_FILE=3

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

RESOURCE_PATH=$DEBIAN_EXTENSION_HOME/xserver/wm/i3/res
RESULT_CONFIG_PATH="~/.config/i3/config"

rm -r $RESULT_CONFIG_PATH

STATUS=0

cp $RESOURCE_PATH/config $RESULT_CONFIG_PATH || STATUS=$?
if test $STATUS -ne 0; then
    echo "Copy config file error!"
    exit $ERROR_CODE_COPY_CONFIG_FILE
fi

RESULT_CONFIG_STATUS_PATH="~/.config/i3status/config"

rm -r $RESULT_CONFIG_STATUS_PATH

cp $RESOURCE_PATH/status/config $RESULT_CONFIG_STATUS_PATH || STATUS=$?
if test $STATUS -ne 0; then
    echo "Copy config status file error!"
    exit $ERROR_CODE_COPY_CONFIG_STATUS_FILE
fi

exit 0
