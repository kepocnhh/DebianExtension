#!/bin/bash

for it in HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ISSUER=telegram

LATEST_VERSIONS="$(curl -s https://api.github.com/repos/telegramdesktop/tdesktop/git/refs/tags \
 | jq -r .[].ref \
 | grep -Po '(?<=v)[1-9]([0-9]|\.)+[0-9]' \
 | sort -V | tail -n 16)"
if test $? -ne 0; then
 echo "Get latest versions $ISSUER error!"; exit 12
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions $ISSUER is empty!"; exit 13
fi

ISSUER_VERSION=""
echo "
Latest 16 versions:
$LATEST_VERSIONS

Enter $ISSUER version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  ISSUER_VERSION+=$char
 fi
done

for it in ISSUER_VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

if test -d /opt/Telegram; then
 echo "${ISSUER^} exists!"; exit 22
fi

BASE_URL="https://github.com/telegramdesktop/tdesktop/releases/download/v${ISSUER_VERSION}"

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="tsetup.${ISSUER_VERSION}.tar.xz"
rm /tmp/$FILE
curl -f -L $BASE_URL/$FILE -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION error!"; exit 31
fi

echo "Unzip $ISSUER ${ISSUER_VERSION}..."
tar -xf /tmp/$FILE -C /opt
if test $? -ne 0; then
 echo "Unzip $ISSUER $ISSUER_VERSION error!"; exit 32
fi
