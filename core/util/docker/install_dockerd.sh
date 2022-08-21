#!/bin/bash

ISSUER=dockerd

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

ISSUER_VERSION=$1
MACHINE_HARDWARE_NAME="$(/usr/bin/uname -m)"

. /etc/os-release

for it in ISSUER_VERSION MACHINE_HARDWARE_NAME ID VERSION_CODENAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

case "$MACHINE_HARDWARE_NAME" in
 'x86_64') ARCHITECTURE=amd64;;
 *) echo "Architecture $MACHINE_HARDWARE_NAME is not supported!"; exit 13;;
esac

apt-get install --no-install-recommends -y iptables
if test $? -ne 0; then
 echo "Install lib error!"; exit 14
fi

BASE_URL=https://download.docker.com/linux/$ID/dists/$VERSION_CODENAME/pool/stable/$ARCHITECTURE

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="docker-ce_${ISSUER_VERSION}~3-0~${ID}-${VERSION_CODENAME}_${ARCHITECTURE}.deb"
rm /tmp/$FILE
curl -f --connect-timeout 2 "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION error!"; exit 21
fi
echo "Install $ISSUER ${ISSUER_VERSION}..."
/usr/bin/dpkg -i /tmp/$FILE
if test $? -ne 0; then
 echo "Install $ISSUER $ISSUER_VERSION error!"; exit 22
fi
rm /tmp/$FILE

dockerd --version
if test $? -ne 0; then
 echo "Running $ISSUER $ISSUER_VERSION error!"; exit 31
fi
