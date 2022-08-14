#!/bin/bash

if test $# -ne 1; then
  echo "Script needs for 1 arguments but actual $#!"; exit 11
fi

GRADLE_VERSION=$1

for it in GRADLE_VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

for it in JAVA_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 22; fi; done

if test -d "/opt/gradle-$GRADLE_VERSION"; then
 echo "Gradle ${GRADLE_VERSION} exists!"; exit 23
fi

BASE_URL="https://services.gradle.org/distributions"

echo "Download gradle ${GRADLE_VERSION}..."
FILE="gradle-${GRADLE_VERSION}-bin.zip"
rm /tmp/$FILE
curl -f -L "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download gradle error!"; exit 31
fi

echo "Download gradle checksum..."
rm /tmp/${FILE}.sha256
curl -f -L "$BASE_URL/${FILE}.sha256" -o /tmp/${FILE}.sha256
if test $? -ne 0; then
 echo "Download gradle checksum error!"; exit 32
fi
echo "$(cat /tmp/${FILE}.sha256) /tmp/$FILE" | sha256sum -c || exit 33
rm /tmp/${FILE}.sha256

echo "Unzip gradle ${GRADLE_VERSION}..."
unzip -d /opt /tmp/$FILE
if test $? -ne 0; then
 echo "Unzip gradle error!"; exit 41
fi
rm /tmp/$FILE

echo "Running gradle ${GRADLE_VERSION}..."
/opt/gradle-${GRADLE_VERSION}/bin/gradle --version
if test $? -ne 0; then
 echo "Running gradle error!"; exit 42
fi

exit 0
