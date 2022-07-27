#!/bin/bash

echo "install default..."

ERROR_CODE_SERVICE=1
ERROR_CODE_COPY=100

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be not empty!"
    exit $ERROR_CODE_SERVICE
fi

DEFAULT_PATH="/etc/default"
array=("console-setup" "keyboard")
SIZE=${#array[@]}
for ((i = 0; i < SIZE; i++)); do
 FILE_NAME="${array[$i]}"
 RESULT_PATH="$DEFAULT_PATH/$FILE_NAME"
 rm "$RESULT_PATH"
 cp "$DEBIAN_EXTENSION_HOME/debian$RESULT_PATH" "$RESULT_PATH"
 if test $? -ne 0; then
  echo "Copy \"$RESULT_PATH\" file error!"
  exit $((ERROR_CODE_COPY + i))
 fi
 echo "Copy \"$RESULT_PATH\" file success."
done

echo "install default success."

exit 0
