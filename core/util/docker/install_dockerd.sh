#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

DOCKERD_VERSION=$1
MACHINE_HARDWARE_NAME="$(/usr/bin/uname -m)"

. /etc/os-release

for it in DOCKERD_VERSION MACHINE_HARDWARE_NAME ID VERSION_CODENAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

case "$MACHINE_HARDWARE_NAME" in
 'x86_64') ARCHITECTURE=amd64;;
 *) echo "Architecture $MACHINE_HARDWARE_NAME is not supported!"; exit 13;;
esac

BASE_URL=https://download.docker.com/linux/$ID/dists/$VERSION_CODENAME/pool/stable/$ARCHITECTURE

echo "Download dockerd ${DOCKERD_VERSION}..."
FILE="docker-ce_${DOCKERD_VERSION}~3-0~${ID}-${VERSION_CODENAME}_${ARCHITECTURE}.deb"
rm /tmp/$FILE
curl -f --connect-timeout 2 "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download dockerd $DOCKERD_VERSION error!"; exit 21
fi
echo "Install dockerd ${DOCKERD_VERSION}..."
/usr/bin/dpkg -i /tmp/$FILE
if test $? -ne 0; then
 echo "Install dockerd $DOCKERD_VERSION error!"; exit 22
fi
rm /tmp/$FILE

dockerd --version
if test $? -ne 0; then
 echo "Running dockerd $DOCKERD_VERSION error!"; exit 31
fi