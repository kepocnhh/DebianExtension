#!/bin/bash

echo "install phase 1..."

ERROR_CODE_SERVICE=10
ERROR_CODE_INSTALL=100

if test -z $DEBIAN_EXTENSION_HOME; then
 echo "Debian extension home path is empty!"
 exit $ERROR_CODE_SERVICE
fi

CODE=0
array=(session media network/bluetooth util)
SIZE=${#array[@]}
for ((i = 0; i < SIZE; i++)); do
 ITEM="${array[$i]}"
 $DEBIAN_EXTENSION_HOME/$ITEM/install.sh; CODE=$?
 if test $CODE -ne 0; then
  echo "Install \"$ITEM\" error $CODE!"
  exit $((ERROR_CODE_INSTALL + i))
 fi
done

echo "install phase 1 success."

exit 0
