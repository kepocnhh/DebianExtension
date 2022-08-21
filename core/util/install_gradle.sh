#!/bin/bash

for it in JAVA_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ISSUER=gradle

LATEST_VERSIONS="$(curl -s --max-time 2 https://services.gradle.org/distributions/ \
 | grep '/distributions/' \
 | grep -Po '(?<=/distributions/gradle-)\S+(?=-bin.zip">)' \
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

if test -d "/opt/gradle-$ISSUER_VERSION"; then
 echo "${ISSUER^} $ISSUER_VERSION exists!"; exit 22
fi

BASE_URL="https://services.gradle.org/distributions"

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="gradle-${ISSUER_VERSION}-bin.zip"
rm /tmp/$FILE
curl -f -L "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION error!"; exit 31
fi

echo "Download $ISSUER $ISSUER_VERSION checksum..."
rm /tmp/${FILE}.sha256
curl -f -L "$BASE_URL/${FILE}.sha256" -o /tmp/${FILE}.sha256
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION checksum error!"; exit 32
fi
echo "$(cat /tmp/${FILE}.sha256) /tmp/$FILE" | sha256sum -c || exit 33
rm /tmp/${FILE}.sha256

echo "Unzip $ISSUER ${ISSUER_VERSION}..."
unzip -d /opt /tmp/$FILE
if test $? -ne 0; then
 echo "Unzip $ISSUER $ISSUER_VERSION error!"; exit 41
fi
rm /tmp/$FILE

echo "Running $ISSUER ${ISSUER_VERSION}..."
/opt/gradle-${ISSUER_VERSION}/bin/gradle --version
if test $? -ne 0; then
 echo "Running $ISSUER $ISSUER_VERSION error!"; exit 42
fi
