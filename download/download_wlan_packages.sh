#!/bin/bash

echo "Download wlan packages..."

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

URL_SOURCE="$URL_BASE/non-free/f/firmware-nonfree"
LATEST_VERSIONS="$(curl -s -f --connect-timeout 4 --max-time 4 "$URL_SOURCE/" \
 | grep -E "_all.deb\">${PACKAGE}_" \
 | grep -Po "(?<=_all.deb\">${PACKAGE}_)\S+(?=_all.deb</a>)" \
 | sort -V | tail -n 4)"
if test $? -ne 0; then
 echo "Get latest versions \"$PACKAGE\" error!"; exit 31
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions \"$PACKAGE\" is empty!"; exit 32
fi

VERSION=""
echo "
Latest 4 versions:
$LATEST_VERSIONS

Enter \"$PACKAGE\" version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  VERSION+=$char
 fi
done

FILE="${PACKAGE}_${VERSION}_all.deb"
URL="$URL_SOURCE/$FILE"
curl -L -f "$URL_SOURCE/$FILE" -o "$FILE_PATH/$FILE"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 21
fi

PACKAGE="libnl-3-200"
VERSION_LIBNL="3.4.0-1+b1_${ARCHITECTURE}"
VERSION=$VERSION_LIBNL

URL_SOURCE="$URL_BASE/main/libn/libnl3"
LATEST_VERSIONS="$(curl -s -f --connect-timeout 4 --max-time 4 "$URL_SOURCE/" \
 | grep -E "_${ARCHITECTURE}.deb\">${PACKAGE}_" \
 | grep -Po "(?<=_${ARCHITECTURE}.deb\">${PACKAGE}_)\S+(?=_${ARCHITECTURE}.deb</a>)" \
 | sort -V | tail -n 8)"
if test $? -ne 0; then
 echo "Get latest versions \"$PACKAGE\" error!"; exit 33
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions \"$PACKAGE\" is empty!"; exit 34
fi

VERSION=""
echo "
Latest 8 versions:
$LATEST_VERSIONS

Enter \"$PACKAGE\" version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  VERSION+=$char
 fi
done

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
curl -L -f "$URL_SOURCE/$FILE" -o "$FILE_PATH/$FILE"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 22
fi

PACKAGE="libnl-genl-3-200"
FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
curl -L -f "$URL_SOURCE/$FILE" -o "$FILE_PATH/$FILE"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 23
fi

PACKAGE="libnl-route-3-200"
FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
curl -L -f "$URL_SOURCE/$FILE" -o "$FILE_PATH/$FILE"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 24
fi

PACKAGE="iw"
VERSION="5.19-1_${ARCHITECTURE}"
URL_SOURCE="$URL_BASE/main/i/iw"
LATEST_VERSIONS="$(curl -s -f --connect-timeout 4 --max-time 4 "$URL_SOURCE/" \
 | grep -E "_${ARCHITECTURE}.deb\">${PACKAGE}_" \
 | grep -Po "(?<=_${ARCHITECTURE}.deb\">${PACKAGE}_)\S+(?=_${ARCHITECTURE}.deb</a>)" \
 | sort -V | tail -n 8)"
if test $? -ne 0; then
 echo "Get latest versions \"$PACKAGE\" error!"; exit 35
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions \"$PACKAGE\" is empty!"; exit 36
fi

VERSION=""
echo "
Latest 8 versions:
$LATEST_VERSIONS

Enter \"$PACKAGE\" version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  VERSION+=$char
 fi
done

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
curl -L -f "$URL_SOURCE/$FILE" -o "$FILE_PATH/$FILE"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 25
fi

PACKAGE="libdbus-1-3"
VERSION="1.12.20-2_${ARCHITECTURE}"
URL_SOURCE="$URL_BASE/main/d/dbus"
LATEST_VERSIONS="$(curl -s -f --connect-timeout 4 --max-time 4 "$URL_SOURCE/" \
 | grep -E "_${ARCHITECTURE}.deb\">${PACKAGE}_" \
 | grep -Po "(?<=_${ARCHITECTURE}.deb\">${PACKAGE}_)\S+(?=_${ARCHITECTURE}.deb</a>)" \
 | sort -V | tail -n 8)"
if test $? -ne 0; then
 echo "Get latest versions \"$PACKAGE\" error!"; exit 37
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions \"$PACKAGE\" is empty!"; exit 38
fi

VERSION=""
echo "
Latest 8 versions:
$LATEST_VERSIONS

Enter \"$PACKAGE\" version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  VERSION+=$char
 fi
done

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
curl -L -f "$URL_SOURCE/$FILE" -o "$FILE_PATH/$FILE"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 26
fi

PACKAGE="libpcsclite1"
VERSION="1.9.1-1_${ARCHITECTURE}"
URL_SOURCE="$URL_BASE/main/p/pcsc-lite"
LATEST_VERSIONS="$(curl -s -f --connect-timeout 4 --max-time 4 "$URL_SOURCE/" \
 | grep -E "_${ARCHITECTURE}.deb\">${PACKAGE}_" \
 | grep -Po "(?<=_${ARCHITECTURE}.deb\">${PACKAGE}_)\S+(?=_${ARCHITECTURE}.deb</a>)" \
 | sort -V | tail -n 8)"
if test $? -ne 0; then
 echo "Get latest versions \"$PACKAGE\" error!"; exit 39
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions \"$PACKAGE\" is empty!"; exit 40
fi

VERSION=""
echo "
Latest 8 versions:
$LATEST_VERSIONS

Enter \"$PACKAGE\" version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  VERSION+=$char
 fi
done

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
curl -L -f "$URL_SOURCE/$FILE" -o "$FILE_PATH/$FILE"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 27
fi

PACKAGE="wpasupplicant"
VERSION="2.9.0-21_${ARCHITECTURE}"
URL_SOURCE="$URL_BASE/main/w/wpa"
LATEST_VERSIONS="$(curl -s -f --connect-timeout 4 --max-time 4 "$URL_SOURCE/" \
 | grep -E "_${ARCHITECTURE}.deb\">${PACKAGE}_" \
 | grep -Po "(?<=_${ARCHITECTURE}.deb\">${PACKAGE}_)\S+(?=_${ARCHITECTURE}.deb</a>)" \
 | sort -V | tail -n 8)"
if test $? -ne 0; then
 echo "Get latest versions \"$PACKAGE\" error!"; exit 41
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions \"$PACKAGE\" is empty!"; exit 42
fi

VERSION=""
echo "
Latest 8 versions:
$LATEST_VERSIONS

Enter \"$PACKAGE\" version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  VERSION+=$char
 fi
done

FILE="${PACKAGE}_${VERSION}_${ARCHITECTURE}.deb"
curl -L -f "$URL_SOURCE/$FILE" -o "$FILE_PATH/$FILE"
if test $? -ne 0; then
 echo "Download \"$PACKAGE\" error!"; exit 28
fi

echo "Download wlan packages success."

exit 0
