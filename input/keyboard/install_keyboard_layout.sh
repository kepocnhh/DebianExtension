echo "install keyboard layout..."

ERROR_CODE_SERVICE=1
ERROR_CODE_COPY_KEYBOARD_LAYOUT_FILE=2
ERROR_CODE_UPDATE_KEYBOARD_LAYOUT=3

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

RESULT_FULL_PATH="/etc/default/keyboard"

rm -r $RESULT_FULL_PATH

STATUS=0

cp $DEBIAN_EXTENSION_HOME/input/keyboard/keyboard $RESULT_FULL_PATH || STATUS=$?
if test $STATUS -ne 0; then
    echo "Copy keyboard layout file error!"
    exit $ERROR_CODE_COPY_KEYBOARD_LAYOUT_FILE
fi

udevadm trigger --subsystem-match=input --action=change || STATUS=$?
if test $STATUS -ne 0; then
    echo "Update keyboard layout error!"
    exit $ERROR_CODE_COPY_SERVICE
fi

exit 0
