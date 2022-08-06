#!/bin/bash

if test $# -ne 2; then
  echo "Script needs for 2 arguments but actual $#!"; exit 11
fi

JAVA_VERSION=$1
DISTRIBUTION=$2 # linux-x64

for it in JAVA_VERSION DISTRIBUTION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 12; fi; done

if test -d "/opt/jdk-${JAVA_VERSION}"; then
 echo "Java ${JAVA_VERSION} exists!"; exit 13
fi

case "$JAVA_VERSION" in
 '12.0.2') INTERMEDIATE="e482c34c86bd4bf8b56c0b35558996b9/10";;
 '17.0.2') INTERMEDIATE="dfd4a8d0985749f896bed50d7138ee7f/8";;
 *) echo "Java version $JAVA_VERSION is not supported!"; exit 14;;
esac

BASE_URL="https://download.java.net/java/GA/jdk${JAVA_VERSION}/${INTERMEDIATE}/GPL"

echo "Download java ${JAVA_VERSION}..."
FILE="openjdk-${JAVA_VERSION}_${DISTRIBUTION}_bin.tar.gz"
rm /tmp/${FILE}
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download java error!"; exit 21
fi

echo "Download java checksum..."
rm /tmp/${FILE}.sha256
curl -f "$BASE_URL/${FILE}.sha256" -o /tmp/${FILE}.sha256
if test $? -ne 0; then
 echo "Download java checksum error!"; exit 22
fi
echo "$(cat /tmp/${FILE}.sha256) /tmp/${FILE}" | sha256sum -c || exit 23
rm /tmp/${FILE}.sha256

echo "Unzip java ${JAVA_VERSION}..."
rm -rf /tmp/jdk-${JAVA_VERSION}
tar -xf /tmp/${FILE} -C /opt
if test $? -ne 0; then
 echo "Unzip java error!"; exit 31
fi
rm /tmp/${FILE}

echo "Running java ${JAVA_VERSION}..."
/opt/jdk-${JAVA_VERSION}/bin/java --version
if test $? -ne 0; then
 echo "Running java error!"; exit 41
fi

exit 0
