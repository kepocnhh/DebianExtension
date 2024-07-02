#!/usr/local/bin/bash

echo 'Download wlan packages...'

if [ ! -d "$HOME" ]; then
 echo "Dir $HOME does not exist!"; exit 11; fi

if test $# -ne 1; then
 echo "Script needs for 1 arguments but actual $#!"; exit 12; fi

ARCHITECTURE=$1

for it in ARCHITECTURE; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

FILE_PATH="$HOME/Downloads/wlan"
rm -rf $FILE_PATH
mkdir -p $FILE_PATH

URL_BASE='http://ftp.debian.org/debian/pool'

PACKAGE='firmware-iwlwifi'
URL_SOURCE="$URL_BASE/non-free/f/firmware-nonfree"

# VERSION='20210315-3'
VERSION='20230210-5~bpo11+1'

FILE="${PACKAGE}_${VERSION}_all.deb"
echo "Download \"$FILE\"..."
curl -f "$URL_SOURCE/$FILE" -o "${FILE_PATH}/${PACKAGE}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 21; fi
echo "${PACKAGE}: ${VERSION}" >> "$FILE_PATH/versions.txt"

PACKAGE='libnl-3-200'
URL_SOURCE="$URL_BASE/main/libn/libnl3"
VERSION='3.7.0-0.3'

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
echo "Download \"$FILE\"..."
curl -f "$URL_SOURCE/$FILE" -o "${FILE_PATH}/${PACKAGE}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 22; fi
echo "${PACKAGE}: ${VERSION}" >> "$FILE_PATH/versions.txt"

PACKAGE='libnl-genl-3-200'
FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
echo "Download \"$FILE\"..."
curl -f "$URL_SOURCE/$FILE" -o "${FILE_PATH}/${PACKAGE}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 23; fi
echo "${PACKAGE}: ${VERSION}" >> "$FILE_PATH/versions.txt"

PACKAGE='libnl-route-3-200'
FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
echo "Download \"$FILE\"..."
curl -f "$URL_SOURCE/$FILE" -o "${FILE_PATH}/${PACKAGE}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 24; fi
echo "${PACKAGE}: ${VERSION}" >> "$FILE_PATH/versions.txt"

PACKAGE='iw'
URL_SOURCE="$URL_BASE/main/i/iw"
VERSION='6.9-1'

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
echo "Download \"$FILE\"..."
curl -f "$URL_SOURCE/$FILE" -o "${FILE_PATH}/${PACKAGE}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 25; fi
echo "${PACKAGE}: ${VERSION}" >> "$FILE_PATH/versions.txt"

PACKAGE='libdbus-1-3'
URL_SOURCE="$URL_BASE/main/d/dbus"
VERSION='1.14.10-1~deb12u1'

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
echo "Download \"$FILE\"..."
curl -f "$URL_SOURCE/$FILE" -o "${FILE_PATH}/${PACKAGE}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 26; fi
echo "${PACKAGE}: ${VERSION}" >> "$FILE_PATH/versions.txt"

PACKAGE='libpcsclite1'
URL_SOURCE="$URL_BASE/main/p/pcsc-lite"
VERSION='2.2.3-1'

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
echo "Download \"$FILE\"..."
curl -f "$URL_SOURCE/$FILE" -o "${FILE_PATH}/${PACKAGE}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 27; fi
echo "${PACKAGE}: ${VERSION}" >> "$FILE_PATH/versions.txt"

PACKAGE='wpasupplicant'
URL_SOURCE="$URL_BASE/main/w/wpa"
VERSION='2.10-12+deb12u1'

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
echo "Download \"$FILE\"..."
curl -f "$URL_SOURCE/$FILE" -o "${FILE_PATH}/${PACKAGE}.deb"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 28; fi
echo "${PACKAGE}: ${VERSION}" >> "$FILE_PATH/versions.txt"

echo 'Download wlan packages success.'

exit 0
