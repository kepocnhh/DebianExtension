#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

for it in DEBIAN_EXTENSION_HOME HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 12; fi; done

SUBLIME_VERSION=$1
DISTRIBUTION='x64'

for it in SUBLIME_VERSION DISTRIBUTION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

if test -d "/opt/sublime-$SUBLIME_VERSION"; then
 echo "Sublime $SUBLIME_VERSION exists!"; exit 22
fi

case "$DISTRIBUTION" in
 'x64') /bin/true;; # ignored
 *) echo "Distribution $DISTRIBUTION is not supported!"; exit 23;;
esac

BASE_URL="https://download.sublimetext.com"

echo "Download sublime key..."
FILE="sublimehq-pub.gpg"
rm /tmp/$FILE
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE && gpg --import /tmp/${FILE} || exit 31
rm /tmp/$FILE

echo "Download sublime ${SUBLIME_VERSION}..."
FILE="sublime_text_build_${SUBLIME_VERSION}_${DISTRIBUTION}.tar.xz"
rm /tmp/$FILE
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download sublime error!"; exit 32
fi

echo "Download sublime $SUBLIME_VERSION signature..."
rm /tmp/${FILE}.asc
curl -f "$BASE_URL/${FILE}.asc" -o /tmp/${FILE}.asc
if test $? -ne 0; then
 echo "Download sublime signature error!"; exit 33
fi

gpg --verify /tmp/${FILE}.asc /tmp/$FILE || exit 34
rm /tmp/${FILE}.asc

echo "Unzip sublime ${SUBLIME_VERSION}..."
rm -rf /tmp/sublime_text
tar -xf /tmp/$FILE -C /tmp
if test $? -ne 0; then
 echo "Unzip sublime $SUBLIME_VERSION error!"; exit 41
fi
rm /tmp/$FILE

echo "Install sublime ${SUBLIME_VERSION}..."
mv /tmp/sublime_text "/opt/sublime-$SUBLIME_VERSION"
if test $? -ne 0; then
 echo "Install sublime $SUBLIME_VERSION error!"; exit 42
fi

RESULT_PATH=$HOME/.config/sublime-text/Packages/User/
mkdir -p $RESULT_PATH
cp $DEBIAN_EXTENSION_HOME/xserver/desktop/config/sublime/* $RESULT_PATH
if test $? -ne 0; then
 echo "Install sublime config error!"; exit 42
fi

/opt/sublime-${SUBLIME_VERSION}/sublime_text --version || exit 44

exit 0
