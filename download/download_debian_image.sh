#!/bin/bash

echo "download debian image..."

ERROR_CODE_SERVICE=11
ERROR_CODE_HOME=12
ERROR_CODE_VERSION_EMPTY=21
ERROR_CODE_ARCHITECTURE_EMPTY=22
ERROR_CODE_DOWNLOAD=31

if test -z "$HOME"; then
    echo "Home path is empty!"
    exit $ERROR_CODE_HOME
fi

ARGUMENT_COUNT_EXPECTED=2
if test $# -ne $ARGUMENT_COUNT_EXPECTED; then
    echo "Script needs for $ARGUMENT_COUNT_EXPECTED arguments but actual $#"
    exit $ERROR_CODE_SERVICE
fi

VERSION=$1
ARCHITECTURE=$2

if test -z "$VERSION"; then
    echo "Version is empty!"
    exit $ERROR_CODE_VERSION_EMPTY
fi
if test -z "$ARCHITECTURE"; then
    echo "Architecture is empty!"
    exit $ERROR_CODE_ARCHITECTURE_EMPTY
fi

URL="https://cdimage.debian.org/debian-cd/current/${ARCHITECTURE}/iso-cd/debian-${VERSION}-${ARCHITECTURE}-netinst.iso"

mkdir -p $HOME/Downloads

FILE_NAME="debian-${VERSION}-${ARCHITECTURE}.iso"

RESULT_PATH="$HOME/Downloads/$FILE_NAME"
rm -f "$RESULT_PATH"

CODE=0
curl -L "$URL" -o "$RESULT_PATH"; CODE=$?
if test $CODE -ne 0; then
 echo "Download error $CODE!"
 exit $ERROR_CODE_DOWNLOAD
fi

echo "download debian image success."

exit 0
