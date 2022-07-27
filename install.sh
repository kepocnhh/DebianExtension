#!/bin/bash

REPOSITORY_OWNER="kepocnhh"
REPOSITORY_NAME="DebianExtension"

echo "Install ${REPOSITORY_OWNER}/${REPOSITORY_NAME}..."

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 21
fi

VERSION=$1

for it in VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 22; fi; done

/usr/bin/apt-get install --no-install-recommends -y git ca-certificates
if test $? -ne 0; then
 echo "Install required error!"; exit 11
fi

FILE_PATH="/usr/local/bin/DebianExtension"
rm -rf $FILE_PATH
mkdir -p $FILE_PATH

git -C $FILE_PATH init \
 && git -C $FILE_PATH remote add origin https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git \
 && git -C $FILE_PATH fetch --depth=1 origin $VERSION \
 && git -C $FILE_PATH checkout FETCH_HEAD
if test $? -ne 0; then
 echo "Clone error!"; exit 13
fi

echo "DEBIAN_EXTENSION_HOME=$FILE_PATH" >> /etc/environment

echo "Install Debian Extension success."

exit 0
