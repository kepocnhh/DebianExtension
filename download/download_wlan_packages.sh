#!/bin/bash

echo "download wlan packages..."

if [ ! -d "$HOME" ]; then
 echo "Dir $HOME does not exist!"; exit 11
fi

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 12
fi

ARCHITECTURE=$1

for it in ARCHITECTURE; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

FILE_PATH="$HOME/Downloads/wlan"
rm -rf $FILE_PATH
mkdir -p $FILE_PATH

URL_BASE="http://ftp.debian.org/debian/pool"

PACKAGE="firmware-iwlwifi"
# VERSION="20190114-2_all" # buster
VERSION="20210818-1_all"
URL="$URL_BASE/non-free/f/firmware-nonfree/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -f -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 21
fi

PACKAGE="libnl-3-200"
# VERSION_LIBNL="3.4.0-1_${ARCHITECTURE}" # buster
VERSION_LIBNL="3.5.0-0.1_${ARCHITECTURE}"
VERSION=$VERSION_LIBNL
URL="$URL_BASE/main/libn/libnl3/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -f -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 22
fi

PACKAGE="libnl-genl-3-200"
VERSION=$VERSION_LIBNL
URL="$URL_BASE/main/libn/libnl3/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -f -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 23
fi

PACKAGE="libnl-route-3-200"
VERSION=$VERSION_LIBNL
URL="$URL_BASE/main/libn/libnl3/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -f -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 24
fi

PACKAGE="iw"
# VERSION="5.0.1-1_${ARCHITECTURE}" # buster
VERSION="5.19-1_${ARCHITECTURE}"
URL="$URL_BASE/main/i/iw/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -f -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 25
fi

PACKAGE="libdbus-1-3"
# VERSION=1.12.20-0+deb10u1_${ARCHITECTURE} # buster
VERSION="1.14.0-2_${ARCHITECTURE}"
URL="$URL_BASE/main/d/dbus/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -f -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 26
fi

PACKAGE="libpcsclite1"
# VERSION="1.8.24-1_${ARCHITECTURE}" # buster
VERSION="1.9.8-1_${ARCHITECTURE}"
URL="$URL_BASE/main/p/pcsc-lite/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -f -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 27
fi

PACKAGE="wpasupplicant"
# VERSION="2.7+git20190128+0c1e29f-6+deb10u2_${ARCHITECTURE}" # buster
VERSION="2.9.0-21_${ARCHITECTURE}"
URL="$URL_BASE/main/w/wpa/${PACKAGE}_${VERSION}.deb"
curl -L "$URL" -f -o "$FILE_PATH/${PACKAGE}_${VERSION}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 28
fi

echo "Download wlan packages success."

exit 0
