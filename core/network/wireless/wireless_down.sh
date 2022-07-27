#!/bin/bash

echo "wireless down..."

ERROR_CODE_SERVICE=11
ERROR_CODE_EMPTY_NETWORK_INTERFACE_NAME=20
ERROR_CODE_ADDRESS_FLUSH=41
ERROR_CODE_ROUTE_FLUSH=42
ERROR_CODE_NETWORK_INTERFACE_DOWN=51
ERROR_CODE_DHCLIENT=70

ARGUMENT_COUNT_EXPECTED=1
if test $# -ne $ARGUMENT_COUNT_EXPECTED; then
 echo "Script needs for $ARGUMENT_COUNT_EXPECTED arguments but actual $#"
 exit $ERROR_CODE_SERVICE
fi

NI_NAME=$1

if test -z $NI_NAME; then
    echo "Network interface name must be not empty!"
    exit $ERROR_CODE_EMPTY_NETWORK_INTERFACE_NAME
fi

CODE=0
/usr/bin/ip addr flush dev $NI_NAME; CODE=$?
if test $CODE -ne 0; then
 echo "Address flush $CODE!"
 exit $ERROR_CODE_ADDRESS_FLUSH
fi
/usr/bin/ip route flush dev $NI_NAME; CODE=$?
if test $CODE -ne 0; then
 echo "Route flush $CODE!"
 exit $ERROR_CODE_ROUTE_FLUSH
fi
/usr/bin/ip link set $NI_NAME down; CODE=$?
if test $CODE -ne 0; then
 echo "Network interface down error $CODE!"
 exit $ERROR_CODE_NETWORK_INTERFACE_DOWN
fi
/usr/sbin/dhclient -r; CODE=$?
if test $CODE -ne 0; then
 echo "dhclient error $CODE!"
 exit $ERROR_CODE_DHCLIENT
fi

echo "wireless down success."

exit 0
