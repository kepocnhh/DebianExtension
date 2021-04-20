#!/bin/bash

echo "download wlan packages..."

ERROR_CODE_SERVICE=11
ERROR_CODE_HOME=12
ERROR_CODE_DOWNLOAD=100

if test -z "$HOME"; then
    echo "Home path is empty!"
    exit $ERROR_CODE_HOME
fi

ARGUMENT_COUNT_EXPECTED=0
if test $# -ne $ARGUMENT_COUNT_EXPECTED; then
    echo "Script needs for $ARGUMENT_COUNT_EXPECTED arguments but actual $#"
    exit $ERROR_CODE_SERVICE
fi

FILE_PATH="$HOME/Downloads/wlan"
rm -rf $FILE_PATH
mkdir -p $FILE_PATH

CODE=0

URL_BASE="http://ftp.debian.org/debian/pool"

PACKAGE="firmware-iwlwifi"
VERSION="20190114-2_all" # buster
#VERSION=20200918-1_all # bullseye
#VERSION=20210315-2_all # sid
URL="$URL_BASE/non-free/f/firmware-nonfree/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"; CODE=$?
if test $CODE -ne 0; then
 echo "Download \"$PACKAGE\" error $CODE!"
 exit $((ERROR_CODE_DOWNLOAD + 1))
fi

PACKAGE="libnl-3-200"
VERSION_LIBNL="3.4.0-1_amd64" # buster
VERSION=$VERSION_LIBNL
URL="$URL_BASE/main/libn/libnl3/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"; CODE=$?
if test $CODE -ne 0; then
 echo "Download \"$PACKAGE\" error $CODE!"
 exit $((ERROR_CODE_DOWNLOAD + 2))
fi

PACKAGE="libnl-genl-3-200"
VERSION=$VERSION_LIBNL
URL="$URL_BASE/main/libn/libnl3/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"; CODE=$?
if test $CODE -ne 0; then
 echo "Download \"$PACKAGE\" error $CODE!"
 exit $((ERROR_CODE_DOWNLOAD + 3))
fi

PACKAGE="libnl-route-3-200"
VERSION=$VERSION_LIBNL
URL="$URL_BASE/main/libn/libnl3/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"; CODE=$?
if test $CODE -ne 0; then
 echo "Download \"$PACKAGE\" error $CODE!"
 exit $((ERROR_CODE_DOWNLOAD + 4))
fi

PACKAGE="iw"
VERSION="5.0.1-1_amd64" # buster
URL="$URL_BASE/main/i/iw/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"; CODE=$?
if test $CODE -ne 0; then
 echo "Download \"$PACKAGE\" error $CODE!"
 exit $((ERROR_CODE_DOWNLOAD + 5))
fi

PACKAGE="libdbus-1-3"
VERSION=1.12.20-0+deb10u1_amd64 # buster
URL="$URL_BASE/main/d/dbus/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"; CODE=$?
if test $CODE -ne 0; then
 echo "Download \"$PACKAGE\" error $CODE!"
 exit $((ERROR_CODE_DOWNLOAD + 6))
fi

PACKAGE="libpcsclite1"
VERSION="1.8.24-1_amd64" # buster
URL="$URL_BASE/main/p/pcsc-lite/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"; CODE=$?
if test $CODE -ne 0; then
 echo "Download \"$PACKAGE\" error $CODE!"
 exit $((ERROR_CODE_DOWNLOAD + 7))
fi

PACKAGE="wpasupplicant"
VERSION="2.7+git20190128+0c1e29f-6+deb10u2_amd64" # buster
URL="$URL_BASE/main/w/wpa/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"; CODE=$?
if test $CODE -ne 0; then
 echo "Download \"$PACKAGE\" error $CODE!"
 exit $((ERROR_CODE_DOWNLOAD + 8))
fi

echo "download wlan packages success."

exit 0
