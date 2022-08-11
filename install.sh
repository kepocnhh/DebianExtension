#!/bin/bash

if test $# -ne 2; then
  echo "Script needs for 2 arguments but actual $#!"; exit 11
fi

OPTION=$1
DEBIAN_EXTENSION_VERSION=$2

for it in OPTION DEBIAN_EXTENSION_VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

REPOSITORY_OWNER="kepocnhh"
REPOSITORY_NAME="DebianExtension"

if test -d "/opt/${REPOSITORY_NAME}-${DEBIAN_EXTENSION_VERSION}"; then
 echo "Debian extension ${DEBIAN_EXTENSION_VERSION} exists!"; exit 13
fi

echo "Install ${REPOSITORY_OWNER}/${REPOSITORY_NAME} ${DEBIAN_EXTENSION_VERSION}..."

BASE_URL="https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}/archive/refs"

case "$OPTION" in
 '-t' | '--tag') BASE_URL="$BASE_URL/tags";;
 '-b' | '--branch') BASE_URL="$BASE_URL/heads";;
 *) echo "Option \"$OPTION\" is not supported!"; exit 21;;
esac

echo "Download $REPOSITORY_NAME ${DEBIAN_EXTENSION_VERSION}..."
FILE="${DEBIAN_EXTENSION_VERSION}.zip"
rm /tmp/$FILE
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $REPOSITORY_NAME $DEBIAN_EXTENSION_VERSION error!"; exit 31
fi

echo "Unzip $REPOSITORY_NAME ${DEBIAN_EXTENSION_VERSION}..."
unzip -d /opt /tmp/$FILE
if test $? -ne 0; then
 echo "Unzip $REPOSITORY_NAME $DEBIAN_EXTENSION_VERSION error!"; exit 32
fi
rm /tmp/$FILE

echo "Install $REPOSITORY_NAME $DEBIAN_EXTENSION_VERSION success."

exit 0
