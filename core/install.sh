#!/bin/bash

echo 'Install core...'

ARRAY=(session media network/bluetooth util)
for ((i = 0; i < ${#ARRAY[@]}; i++)); do
 ITEM="${ARRAY[$i]}"
 ./core/$ITEM/install.sh
 if test $? -ne 0; then
  echo "Install \"$ITEM\" error!"; exit $((20 + i)); fi
done

echo 'Install core success.'

exit 0
