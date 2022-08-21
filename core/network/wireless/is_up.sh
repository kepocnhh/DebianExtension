#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

NI_NAME=$1

for it in NI_NAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

FLAGS=/sys/class/net/$NI_NAME/flags

if [ ! -s "$FLAGS" ]; then
 echo "File $FLAGS does not exist!"; exit 13
fi

NI_STATE=$(cat $FLAGS)
case "$NI_STATE" in
 0x1003) echo up;;
 0x1002) echo down;;
 *) echo "Network interface $NI_NAME state $NI_STATE error!"; exit 21;;
esac

exit 0
