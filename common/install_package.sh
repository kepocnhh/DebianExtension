#!/bin/bash

echo "Install package..."

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 12
fi

PACKAGE_NAME=$1

for it in PACKAGE_NAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

apt-get install --no-install-recommends -y "$PACKAGE_NAME"
if test $? -ne 0; then
 echo "Install package \"$PACKAGE_NAME\" error!"; exit 21
fi

echo "Install package \"$PACKAGE_NAME\" success."

exit 0
