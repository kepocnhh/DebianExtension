#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

CONTAINERD_VERSION=$1
MACHINE_HARDWARE_NAME="$(/usr/bin/uname -m)"

. /etc/os-release

for it in CONTAINERD_VERSION MACHINE_HARDWARE_NAME ID VERSION_CODENAME; do
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

echo "Download containerd ${CONTAINERD_VERSION}..."
FILE="containerd.io_${CONTAINERD_VERSION}-1_${ARCHITECTURE}.deb"
rm /tmp/$FILE
curl -f --connect-timeout 2 "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download containerd $CONTAINERD_VERSION error!"; exit 21
fi
echo "Install containerd ${CONTAINERD_VERSION}..."
/usr/bin/dpkg -i /tmp/$FILE
if test $? -ne 0; then
 echo "Install containerd $CONTAINERD_VERSION error!"; exit 22
fi
rm /tmp/$FILE

containerd --version
if test $? -ne 0; then
 echo "Running containerd $CONTAINERD_VERSION error!"; exit 31
fi
