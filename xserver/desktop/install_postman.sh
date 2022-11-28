#!/bin/bash

for it in HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ISSUER=postman

ISSUER_VERSION='latest'
MACHINE_HARDWARE_NAME="$(/usr/bin/uname -m)"

for it in ISSUER_VERSION MACHINE_HARDWARE_NAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

if test -d "$HOME/.local/Postman"; then
 echo "${ISSUER^} exists!"; exit 22
fi

case "$MACHINE_HARDWARE_NAME" in
 'x86_64') DISTRIBUTION='linux64';;
 *) echo "Distribution $MACHINE_HARDWARE_NAME is not supported!"; exit 31;;
esac

apt-get install --no-install-recommends -y xdg-utils
if test $? -ne 0; then
 echo "Install lib error!"; exit 32
fi

BASE_URL="https://dl.pstmn.io/download/$ISSUER_VERSION/$DISTRIBUTION"

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="${ISSUER}-${ISSUER_VERSION}.tar.gz"
rm /tmp/$FILE
curl -f "$BASE_URL" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION error!"; exit 41
fi

echo "Unzip $ISSUER ${ISSUER_VERSION}..."
rm -rf /tmp/Postman/
tar -xf /tmp/$FILE -C /tmp/
if test $? -ne 0; then
 echo "Unzip $ISSUER $ISSUER_VERSION error!"; exit 42
fi

echo "Install $ISSUER ${ISSUER_VERSION}..."
if [ ! -d "$HOME/.local" ]; then
 mkdir "$HOME/.local" || exit 51 # todo
fi
mv /tmp/Postman/app "$HOME/.local/Postman"
if test $? -ne 0; then
 echo "Install $ISSUER $ISSUER_VERSION error!"; exit 52
fi
rm -rf /tmp/Postman/
