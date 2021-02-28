ERROR_CODE_SERVICE=1

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh playerctl

exit 0
