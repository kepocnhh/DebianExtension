echo "install package..."

ERROR_CODE_SERVICE=1
ERROR_CODE_EMPTY_PACKAGE_NAME=2
ERROR_CODE_INSTALL_APP=3

if test $# -ne 1; then
    echo "Script needs for 1 arguments but actual $#"
    exit $ERROR_CODE_SERVICE
fi

PACKAGE_NAME=$1

if test -z $PACKAGE_NAME; then
    echo "Package name must be not empty!"
    exit $ERROR_CODE_EMPTY_PACKAGE_NAME
fi

echo "install package \"$PACKAGE_NAME\" start."

STATUS=0

apt-get install -y --no-install-recommends $PACKAGE_NAME || STATUS=$?
if test $STATUS -ne 0; then
	echo "install package \"$PACKAGE_NAME\" error!"
    exit $ERROR_CODE_INSTALL_APP
fi

echo "install package \"$PACKAGE_NAME\" success."

exit 0
