#!/bin/bash

if test $# -ne 2; then
  echo "Script needs for 2 arguments but actual $#!"; exit 11
fi

SUBLIME_VERSION=$1
DISTRIBUTION=$2 # x64

for it in SUBLIME_VERSION DISTRIBUTION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

if test -d "/opt/sublime-${SUBLIME_VERSION}"; then
 echo "Sublime ${SUBLIME_VERSION} exists!"; exit 13
fi

BASE_URL="https://download.sublimetext.com"

echo "Download sublime key..."
FILE="sublimehq-pub.gpg"
rm /tmp/${FILE}
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE && gpg --import /tmp/${FILE} || exit 21
rm /tmp/${FILE}

echo "Download sublime ${SUBLIME_VERSION}..."
FILE="sublime_text_build_${SUBLIME_VERSION}_${DISTRIBUTION}.tar.xz"
rm /tmp/${FILE}
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download sublime error!"; exit 22
fi

echo "Download sublime ${SUBLIME_VERSION} signature..."
rm /tmp/${FILE}.asc
curl -f "$BASE_URL/${FILE}.asc" -o /tmp/${FILE}.asc
if test $? -ne 0; then
 echo "Download sublime signature error!"; exit 23
fi

gpg --verify /tmp/${FILE}.asc /tmp/$FILE || exit 24
rm /tmp/${FILE}.asc

echo "Unzip sublime ${SUBLIME_VERSION}..."
rm -rf /tmp/sublime_text
tar -xf /tmp/${FILE} -C /tmp
if test $? -ne 0; then
 echo "Unzip sublime error!"; exit 31
fi

echo "Install sublime ${SUBLIME_VERSION}..."
sudo mv /tmp/sublime_text "/opt/sublime-${SUBLIME_VERSION}"
if test $? -ne 0; then
 echo "Install sublime error!"; exit 32
fi

rm /tmp/${FILE}
/opt/sublime-${SUBLIME_VERSION}/sublime_text --version || exit 33

exit 0
