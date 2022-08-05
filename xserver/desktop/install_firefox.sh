#!/bin/bash

if test $# -ne 3; then
  echo "Script needs for 3 arguments but actual $#!"; exit 12
fi

FIREFOX_VERSION=$1
DISTRIBUTION=$2 # linux-x86_64
LANGUAGE=$3 # en-US

for it in FIREFOX_VERSION DISTRIBUTION LANGUAGE; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

if test -d "/opt/mozilla/firefox-${FIREFOX_VERSION}"; then
 echo "Firefox ${FIREFOX_VERSION} exists!"; exit 14
fi

sudo apt-get install --no-install-recommends -y libgtk-3-0 libdbus-glib-1-2
if test $? -ne 0; then
 echo "Install lib error!"; exit 21
fi

BASE_URL="https://ftp.mozilla.org/pub/firefox/releases/$FIREFOX_VERSION"

echo "Download firefox key..."
FILE="firefox-pub.gpg"
rm /tmp/${FILE}
curl -f "$BASE_URL/KEY" -o /tmp/$FILE && gpg --import /tmp/${FILE} || exit 31
rm /tmp/${FILE}

echo "Download firefox ${FIREFOX_VERSION}..."
FILE="firefox-${FIREFOX_VERSION}.tar.bz2"
rm /tmp/${FILE}
curl -f "$BASE_URL/$DISTRIBUTION/$LANGUAGE/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download firefox error!"; exit 32
fi

echo "Download firefox ${FIREFOX_VERSION} signature..."
rm /tmp/${FILE}.asc
curl -f "$BASE_URL/$DISTRIBUTION/$LANGUAGE/${FILE}.asc" -o /tmp/${FILE}.asc
if test $? -ne 0; then
 echo "Download firefox signature error!"; exit 33
fi

gpg --verify /tmp/${FILE}.asc /tmp/$FILE || exit 34
rm /tmp/${FILE}.asc

echo "Unzip firefox ${FIREFOX_VERSION}..."
rm -rf /tmp/firefox
tar -xf /tmp/${FILE} -C /tmp
if test $? -ne 0; then
 echo "Unzip firefox error!"; exit 41
fi

echo "Install firefox ${FIREFOX_VERSION}..."
if [ ! -d "/opt/mozilla" ]; then
 sudo mkdir "/opt/mozilla" || exit 1 # todo
fi
sudo mv /tmp/firefox "/opt/mozilla/firefox-${FIREFOX_VERSION}"
if test $? -ne 0; then
 echo "Install firefox error!"; exit 42
fi

rm /tmp/${FILE}
echo "Running firefox ${FIREFOX_VERSION}..."
/opt/mozilla/firefox-${FIREFOX_VERSION}/firefox --version
if test $? -ne 0; then
 echo "Running firefox error!"; exit 43
fi

exit 0
