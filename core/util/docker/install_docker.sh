#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

DOCKER_VERSION=$1
MACHINE_HARDWARE_NAME="$(/usr/bin/uname -m)"

. /etc/os-release

for it in MACHINE_HARDWARE_NAME ID VERSION_CODENAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

case "$MACHINE_HARDWARE_NAME" in
 'x86_64') ARCHITECTURE=amd64;;
 *) echo "Architecture $MACHINE_HARDWARE_NAME is not supported!"; exit 13;;
esac

BASE_URL=https://download.docker.com/linux/$ID/dists/$VERSION_CODENAME/pool/stable/$ARCHITECTURE

echo "Download docker ${DOCKER_VERSION}..."
FILE="docker-ce-cli_${DOCKER_VERSION}~3-0~${ID}-${VERSION_CODENAME}_${ARCHITECTURE}.deb"
rm /tmp/$FILE
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download docker $DOCKER_VERSION error!"; exit 21
fi
echo "Install docker ${DOCKER_VERSION}..."
/usr/bin/dpkg -i /tmp/$FILE
if test $? -ne 0; then
 echo "Install docker $DOCKER_VERSION error!"; exit 22
fi
docker --version
rm /tmp/$FILE
