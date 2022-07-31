#!/bin/bash

echo "Install packages..."

if test $# -eq 0; then
 echo "No packages!"; exit 11
fi

PACKAGES=$1

for it in PACKAGES; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

apt-get install --no-install-recommends -y "$PACKAGES"
if test $? -ne 0; then
 echo "Install packages [\"$PACKAGES\"] error!"; exit 21
fi

echo "Install packages [\"$PACKAGES\"] success."

exit 0
