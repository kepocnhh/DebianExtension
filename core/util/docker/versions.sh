#!/bin/bash

MACHINE_HARDWARE_NAME="$(/usr/bin/uname -m)"

. /etc/os-release

for it in MACHINE_HARDWARE_NAME ID VERSION_CODENAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 11; fi; done

case "$MACHINE_HARDWARE_NAME" in
 'x86_64') ARCHITECTURE=amd64;;
 *) echo "Architecture $MACHINE_HARDWARE_NAME is not supported!"; exit 12;;
esac

BASE_URL=https://download.docker.com/linux/$ID/dists/$VERSION_CODENAME/pool/stable/$ARCHITECTURE

curl -s --max-time 2 ${BASE_URL}/ \
 | grep -Eo '^<a href="\S+">\S+</a>' \
 | grep -Eo '.deb">\S+.deb</a>' \
 | grep -Po '(?<=.deb">)\S+(?=.deb</a>)' || exit 1
