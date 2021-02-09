echo "install xresources..."

ERROR_CODE_SERVICE=1
ERROR_CODE_COPY_XRESOURCES_FILE=2

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

RESULT_XRESOURCES_PATH="~/.Xresources"

rm -r $RESULT_XRESOURCES_PATH

STATUS=0

cp $DEBIAN_EXTENSION_HOME/xserver/wm/res/.Xresources $RESULT_XRESOURCES_PATH || STATUS=$?
if test $STATUS -ne 0; then
    echo "Copy xresources file error!"
    exit $ERROR_CODE_COPY_XRESOURCES_FILE
fi

exit 0
