#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

IDEA_VERSION=$1

for it in IDEA_VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

for it in JAVA_HOME GRADLE_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 22; fi; done

if test -d "/opt/jetbrains/idea-$IDEA_VERSION"; then
 echo "Idea ${IDEA_VERSION} exists!"; exit 23
fi

BASE_URL="https://download.jetbrains.com/idea"

echo "Download idea ${IDEA_VERSION}..."
FILE="ideaIC-${IDEA_VERSION}.tar.gz"
rm /tmp/$FILE
curl -f -L "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download idea error!"; exit 31
fi

echo "Download idea checksum..."
rm /tmp/${FILE}.sha256
curl -f "$BASE_URL/${FILE}.sha256" -o /tmp/${FILE}.sha256
if test $? -ne 0; then
 echo "Download idea checksum error!"; exit 32
fi
echo "$(cat /tmp/${FILE}.sha256 | cut -d ' ' -f 1) /tmp/$FILE" | sha256sum -c || exit 33
rm /tmp/${FILE}.sha256

echo "Unzip idea ${IDEA_VERSION}..."
rm -rf /tmp/idea-IC-*
tar -xf /tmp/$FILE -C /tmp
if test $? -ne 0; then
 echo "Unzip idea error!"; exit 41
fi

echo "Install idea ${IDEA_VERSION}..."
if [ ! -d "/opt/jetbrains" ]; then
 mkdir "/opt/jetbrains" || exit 1 # todo
fi
mv /tmp/idea-IC-* "/opt/jetbrains/idea-${IDEA_VERSION}"
if test $? -ne 0; then
 echo "Install idea error!"; exit 42
fi
rm /tmp/$FILE

exit 0
