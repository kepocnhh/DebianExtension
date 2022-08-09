#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

TELEGRAM_VERSION=$1

for it in TELEGRAM_VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

for it in HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 22; fi; done

if test -d /opt/Telegram; then
 echo "Telegram exists!"; exit 23
fi

BASE_URL="https://github.com/telegramdesktop/tdesktop/releases/download/v${TELEGRAM_VERSION}"

echo "Download telegram ${TELEGRAM_VERSION}..."
FILE="tsetup.${TELEGRAM_VERSION}.tar.xz"
rm /tmp/$FILE
curl -f -L $BASE_URL/$FILE -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download telegram $TELEGRAM_VERSION error!"; exit 31
fi

echo "Unzip telegram ${TELEGRAM_VERSION}..."
rm -rf /tmp/Telegram
tar -xf /tmp/$FILE -C /opt
if test $? -ne 0; then
 echo "Unzip telegram $TELEGRAM_VERSION error!"; exit 41
fi

exit 0
