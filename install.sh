#!/bin/bash

echo "install Debian Extension..."

ERROR_CODE_INSTALL=10
ERROR_CODE_REMOVE=20
ERROR_CODE_CLONE=30

CODE=0
/usr/bin/apt-get install -y --no-install-recommends git ca-certificates; CODE=$?
if test $CODE -ne 0; then
 echo "Install required error $CODE!"
 exit $ERROR_CODE_INSTALL
fi

PATH="/usr/local/bin/DebianExtension"
if test -d "$PATH"; then
 /usr/bin/rm -rf $PATH; CODE=$?
 if test $CODE -ne 0; then
  echo "Remove error $CODE!"
  exit $ERROR_CODE_REMOVE
 fi
fi
/usr/bin/git clone https://github.com/kepocnhh/DebianExtension.git $PATH; CODE=$?
if test $CODE -ne 0; then
 echo "Clone error $CODE!"
 exit $ERROR_CODE_CLONE
fi

echo "DEBIAN_EXTENSION_HOME=$PATH" >> /etc/environment

echo "install Debian Extension success."

exit 0
