#!/bin/bash

echo "Download debian image..."

if [ ! -d "$HOME" ]; then
 echo "Dir $HOME does not exist!"; exit 11
fi

if test $# -ne 2; then
  echo "Script needs for 2 arguments but actual $#!"; exit 12
fi

VERSION=$1
ARCHITECTURE=$2

for it in VERSION ARCHITECTURE; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

URL="https://cdimage.debian.org/debian-cd/current/${ARCHITECTURE}/iso-cd/debian-${VERSION}-${ARCHITECTURE}-netinst.iso"

mkdir -p $HOME/Downloads

FILE_NAME="debian-${VERSION}-${ARCHITECTURE}.iso"

RESULT_PATH="$HOME/Downloads/$FILE_NAME"
rm -f "$RESULT_PATH"

curl -L "$URL" -o "$RESULT_PATH"
if test $? -ne 0; then
 echo "Download error!"; exit 14
fi

echo "Download debian image success."

exit 0
