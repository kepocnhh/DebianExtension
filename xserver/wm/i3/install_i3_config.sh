echo "install i3 config..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_HOME=11
ERROR_CODE_COPY_CONFIG_FILE=21
ERROR_CODE_COPY_CONFIG_STATUS_FILE=31
ERROR_CODE_MAKE_BIN_DIR=41
ERROR_CODE_COPY_STATUS_COMMAND=51

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be non-empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi
if test -z $HOME; then
    echo "Home path must be non-empty!"
    exit $ERROR_CODE_HOME
fi

I3_PATH=$DEBIAN_EXTENSION_HOME/xserver/wm/i3
RESOURCE_PATH=$I3_PATH/res
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

BIN_PATH="$HOME/.bin"
STATUS_COMMAND_NAME="status_command.sh"
RESULT_STATUS_COMMAND_PATH="$BIN_PATH/$STATUS_COMMAND_NAME"

rm "$RESULT_STATUS_COMMAND_PATH"

mkdir "$BIN_PATH"
if test $? -ne 0; then
    echo "Make bin dir $BIN_PATH error!"
    exit $ERROR_CODE_MAKE_BIN_DIR
fi

cp "$I3_PATH/status/$STATUS_COMMAND_NAME" "$RESULT_STATUS_COMMAND_PATH"
if test $? -ne 0; then
    echo "Copy status command file error!"
    exit $ERROR_CODE_COPY_STATUS_COMMAND
fi

echo "install i3 config success"

exit 0
