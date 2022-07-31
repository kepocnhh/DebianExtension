#!/bin/bash

if test -d "/opt/mozilla/firefox-${FIREFOX_VERSION}"; then
 echo "Firefox ${FIREFOX_VERSION} exists!"; exit 101
fi

if test $# -ne 3; then
  echo "Script needs for 3 arguments but actual $#!"; exit 12
fi

FIREFOX_VERSION=$1
DISTRIBUTION=$2 # linux-x86_64
LANGUAGE=$3 # en-US

for it in FIREFOX_VERSION DISTRIBUTION LANGUAGE; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done


URL="https://ftp.mozilla.org/pub/firefox/releases/$FIREFOX_VERSION/$DISTRIBUTION/$LANGUAGE"

echo "Download firefox ${FIREFOX_VERSION}..."
FILE="firefox-${FIREFOX_VERSION}.tar.bz2"
rm /tmp/${FILE}
curl -f "$URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download firefox error!"; exit 11
fi

echo "Unzip firefox ${FIREFOX_VERSION}..."
rm -rf /tmp/firefox
tar -xf /tmp/${FILE} -C /tmp
if test $? -ne 0; then
 echo "Unzip firefox error!"; exit 21
fi

echo "Install firefox ${FIREFOX_VERSION}..."
if [ ! -d "/opt/mozilla" ]; then
 sudo mkdir "/opt/mozilla" || exit 1 # todo
fi
sudo mv /tmp/firefox "/opt/mozilla/firefox-${FIREFOX_VERSION}"
if test $? -ne 0; then
 echo "Install firefox error!"; exit 31
fi

rm /tmp/${FILE}
echo "Running firefox ${FIREFOX_VERSION}..."
/opt/mozilla/firefox-${FIREFOX_VERSION}/firefox --version
if test $? -ne 0; then
 echo "Running firefox error!"; exit 41
fi

exit 0
