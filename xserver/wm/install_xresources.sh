echo "install xresources..."

ERROR_CODE_SERVICE=10
ERROR_CODE_HOME=11
ERROR_CODE_COPY=2

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi
if test -z $HOME; then
    echo "Home path must be non-empty!"
    exit $ERROR_CODE_HOME
fi

RESULT_PATH="$HOME/.Xresources"

rm $RESULT_PATH

cp $DEBIAN_EXTENSION_HOME/xserver/wm/res/.Xresources $RESULT_PATH
if test $? -ne 0; then
    echo "Copy xresources file error!"
    exit $ERROR_CODE_COPY
fi

exit 0
