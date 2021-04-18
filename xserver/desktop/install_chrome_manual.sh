#!/bin/bash

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_DOWNLOAD=11
ERROR_CODE_INSTALL=21
ERROR_CODE_COPY=31

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be non-empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi

echo "download chrome..."

#VERSION="78.0.3904.87-1"
VERSION="87.0.4280.66-1"
#VERSION="89.0.4389.90-1"
#VERSION="90.0.4430.72-1"
DOWNLOAD_URL=http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${VERSION}_amd64.deb

TMP_FILE_PATH=/tmp/chrome.deb

curl -s "$DOWNLOAD_URL" -o "$TMP_FILE_PATH"
if test $? -ne 0; then
	echo "download chrome error!"
    exit $ERROR_CODE_DOWNLOAD
fi

echo "install chrome..."

apt install -y "$TMP_FILE_PATH"
if test $? -ne 0; then
    echo "install chrome error!"
    exit $ERROR_CODE_INSTALL
fi

rm $TMP_FILE_PATH

cp $DEBIAN_EXTENSION_HOME/xserver/desktop/chrome.sh /usr/local/bin/chrome.sh
if test $? -ne 0; then
	echo "Copy chrome executable error!"
    exit $ERROR_CODE_COPY
fi

echo "install chrome success."

exit 0
