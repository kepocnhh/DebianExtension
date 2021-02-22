echo "install i3 config..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_HOME=11
ERROR_CODE_COPY_CONFIG_FILE=2
ERROR_CODE_COPY_CONFIG_STATUS_FILE=3

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be non-empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi
if test -z $HOME; then
    echo "Home path must be non-empty!"
    exit $ERROR_CODE_HOME
fi

RESOURCE_PATH=$DEBIAN_EXTENSION_HOME/xserver/wm/i3/res
RESULT_CONFIG_PATH="$HOME/.config/i3/config"

rm $RESULT_CONFIG_PATH

cp $RESOURCE_PATH/config $RESULT_CONFIG_PATH
if test $? -ne 0; then
    echo "Copy config file error!"
    exit $ERROR_CODE_COPY_CONFIG_FILE
fi

RESULT_CONFIG_STATUS_PATH="$HOME/.config/i3status/config"

rm $RESULT_CONFIG_STATUS_PATH

cp $RESOURCE_PATH/status/config $RESULT_CONFIG_STATUS_PATH
if test $? -ne 0; then
    echo "Copy config status file error!"
    exit $ERROR_CODE_COPY_CONFIG_STATUS_FILE
fi

echo "install i3 config success"

exit 0
