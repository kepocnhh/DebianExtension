#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

PYTHON_VERSION=$1

for it in PYTHON_VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

if test -d "/opt/python-$PYTHON_VERSION"; then
 echo "Python ${PYTHON_VERSION} exists!"; exit 13
fi

echo "Download python key..."
FILE="pgp_keys.asc"
rm /tmp/$FILE
curl -f "https://keybase.io/pablogsal/$FILE" -o /tmp/$FILE && gpg --import /tmp/$FILE || exit 41
rm /tmp/$FILE

BASE_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}"

echo "Download python ${PYTHON_VERSION}..."
FILE="Python-${PYTHON_VERSION}.tgz"
rm /tmp/$FILE
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download python error!"; exit 42
fi

echo "Download python $PYTHON_VERSION signature..."
rm /tmp/${FILE}.asc
curl -f "$BASE_URL/${FILE}.asc" -o /tmp/${FILE}.asc
if test $? -ne 0; then
 echo "Download python $PYTHON_VERSION signature error!"; exit 43
fi

gpg --verify /tmp/${FILE}.asc /tmp/$FILE || exit 44
rm /tmp/${FILE}.asc

exit 1 # todo

echo "Running java ${JAVA_VERSION}..."
/opt/jdk-${JAVA_VERSION}/bin/java --version
if test $? -ne 0; then
 echo "Running java error!"; exit 42
fi
