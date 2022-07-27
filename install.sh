#!/bin/bash

REPOSITORY_OWNER="kepocnhh"
REPOSITORY_NAME="DebianExtension"

echo "Install ${REPOSITORY_OWNER}/${REPOSITORY_NAME}..."

/usr/bin/apt-get install --no-install-recommends -y git ca-certificates
if test $? -ne 0; then
 echo "Install required error!"; exit 11
fi

PATH="/usr/local/bin/DebianExtension"
if test -d "$PATH"; then
 /usr/bin/rm -rf $PATH
 if test $? -ne 0; then
  echo "Delete \"$PATH\" error!"; exit 12
 fi
fi

/usr/bin/git clone https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git $PATH
if test $? -ne 0; then
 echo "Clone error!"; exit 13
fi

echo "DEBIAN_EXTENSION_HOME=$PATH" >> /etc/environment

echo "Install Debian Extension success."

exit 0
