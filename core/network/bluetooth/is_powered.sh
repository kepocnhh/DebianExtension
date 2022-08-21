#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 12
fi

BT_MAC=$1

for it in BT_MAC; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

BT_INFO=$(/usr/bin/bluetoothctl show $BT_MAC) \
 && case "$(echo "$BT_INFO" | grep Powered: | sed 's/\t//g')" in
 "Powered: yes") echo yes;;
 "Powered: no") echo no;;
 *) echo "Powered state error!"; exit 1;;
esac || exit 2
