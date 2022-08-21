#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

NI_NAME=$1

for it in NI_NAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

/usr/bin/ip addr flush dev $NI_NAME
if test $? -ne 0; then
 echo "Address flush!"; exit 21
fi
/usr/bin/ip route flush dev $NI_NAME
if test $? -ne 0; then
 echo "Route flush!"; exit 22
fi
/usr/bin/ip link set $NI_NAME down
if test $? -ne 0; then
 echo "Network interface down error!"; exit 23
fi
/usr/sbin/dhclient -r
if test $? -ne 0; then
 echo "dhclient error!"; exit 24
fi

exit 0
