#!/bin/bash

echo "Install default..."

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

DEFAULT_PATH="/etc/default"
ARRAY=("console-setup" "keyboard")
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 FILE_NAME="${ARRAY[$i]}"
 RESULT_PATH="$DEFAULT_PATH/$FILE_NAME"
 rm "$RESULT_PATH"
 cp "$DEBIAN_EXTENSION_HOME/debian$RESULT_PATH" "$RESULT_PATH"
 if test $? -ne 0; then
  echo "Copy \"$FILE_NAME\" file error!"; exit $((20 + i))
 fi
 echo "Copy \"$RESULT_PATH\" file success."
done

echo "Install default success."

exit 0
