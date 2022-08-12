#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

FIREFOX_VERSION=$1
DISTRIBUTION='linux-x86_64'
LANGUAGE='en-US'

for it in FIREFOX_VERSION DISTRIBUTION LANGUAGE; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

if test -d "/opt/mozilla/firefox-$FIREFOX_VERSION"; then
 echo "Firefox $FIREFOX_VERSION exists!"; exit 22
fi

case "$DISTRIBUTION" in
 'linux-x86_64') /bin/true;; # ignored
 *) echo "Distribution $DISTRIBUTION is not supported!"; exit 23;;
esac

case "$LANGUAGE" in
 'en-US') /bin/true;; # ignored
 *) echo "Distribution $DISTRIBUTION is not supported!"; exit 24;;
esac

apt-get install --no-install-recommends -y libgtk-3-0 libdbus-glib-1-2
if test $? -ne 0; then
 echo "Install lib error!"; exit 31
fi

BASE_URL="https://ftp.mozilla.org/pub/firefox/releases/$FIREFOX_VERSION"

echo "Download firefox key..."
FILE="firefox-pub.gpg"
rm /tmp/$FILE
curl -f "$BASE_URL/KEY" -o /tmp/$FILE && gpg --import /tmp/$FILE || exit 41
rm /tmp/$FILE

echo "Download firefox ${FIREFOX_VERSION}..."
FILE="firefox-${FIREFOX_VERSION}.tar.bz2"
rm /tmp/$FILE
curl -f "$BASE_URL/$DISTRIBUTION/$LANGUAGE/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download firefox error!"; exit 42
fi

echo "Download firefox $FIREFOX_VERSION signature..."
rm /tmp/${FILE}.asc
curl -f "$BASE_URL/$DISTRIBUTION/$LANGUAGE/${FILE}.asc" -o /tmp/${FILE}.asc
if test $? -ne 0; then
 echo "Download firefox signature error!"; exit 43
fi

gpg --verify /tmp/${FILE}.asc /tmp/$FILE || exit 44
rm /tmp/${FILE}.asc

echo "Unzip firefox ${FIREFOX_VERSION}..."
rm -rf /tmp/firefox
tar -xf /tmp/$FILE -C /tmp
if test $? -ne 0; then
 echo "Unzip firefox error!"; exit 51
fi

echo "Install firefox ${FIREFOX_VERSION}..."
if [ ! -d "/opt/mozilla" ]; then
 mkdir "/opt/mozilla" || exit 52 # todo
fi
mv /tmp/firefox "/opt/mozilla/firefox-$FIREFOX_VERSION"
if test $? -ne 0; then
 echo "Install firefox error!"; exit 53
fi

rm /tmp/$FILE
# todo sudo error
# echo "Running firefox ${FIREFOX_VERSION}..."
# /opt/mozilla/firefox-${FIREFOX_VERSION}/firefox --version
# if test $? -ne 0; then
#  echo "Running firefox error!"; exit 54
# fi

exit 0
