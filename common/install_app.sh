echo "install app..."

ERROR_CODE_SERVICE=1
ERROR_CODE_EMPTY_APP_NAME=2
ERROR_CODE_INSTALL_APP=3

if test $# -ne 1; then
    echo "Script needs for 1 arguments but actual $#"
    exit $ERROR_CODE_SERVICE
fi

APP_NAME=$1

if test -z $APP_NAME; then
    echo "App name must be not empty!"
    exit $ERROR_CODE_EMPTY_APP_NAME
fi

echo "install $APP_NAME start."

STATUS=0

apt-get install -qq --no-install-recommends curl || STATUS=$?
if test $STATUS -ne 0; then echo "install $APP_NAME error!"
    exit $ERROR_CODE_INSTALL_APP
fi

echo "install $APP_NAME success."

exit 0
