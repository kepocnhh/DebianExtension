#!/bin/bash

ISSUER=java

LATEST_VERSIONS="$(curl -s --max-time 2 https://jdk.java.net/archive/ \
 | grep '(build ' \
 | grep -Po '(?<=<th>)\S+' \
 | sort -V)"
if test $? -ne 0; then
 echo "Get latest versions $ISSUER error!"; exit 11
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions $ISSUER is empty!"; exit 12
fi

ISSUER_VERSION=""
echo "
Latest versions:
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

MACHINE_HARDWARE_NAME="$(/usr/bin/uname -m)"

for it in ISSUER_VERSION MACHINE_HARDWARE_NAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 13; fi; done

if test -d "/opt/jdk-$ISSUER_VERSION"; then
 echo "${ISSUER^} $ISSUER_VERSION exists!"; exit 14
fi

case "$MACHINE_HARDWARE_NAME" in
 'x86_64') DISTRIBUTION='linux-x64';;
 *) echo "Architecture $MACHINE_HARDWARE_NAME is not supported!"; exit 15;;
esac

case "$ISSUER_VERSION" in
 '12.0.2') INTERMEDIATE="e482c34c86bd4bf8b56c0b35558996b9/10";;
 '17.0.2') INTERMEDIATE="dfd4a8d0985749f896bed50d7138ee7f/8";;
 *) echo "${ISSUER^} version $ISSUER_VERSION is not supported!"; exit 16;;
esac

BASE_URL="https://download.java.net/java/GA/jdk${ISSUER_VERSION}/${INTERMEDIATE}/GPL"

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="openjdk-${ISSUER_VERSION}_${DISTRIBUTION}_bin.tar.gz"
rm /tmp/$FILE
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION error!"; exit 21
fi

echo "Download $ISSUER $ISSUER_VERSION checksum..."
rm /tmp/${FILE}.sha256
curl -f "$BASE_URL/${FILE}.sha256" -o /tmp/${FILE}.sha256
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION checksum error!"; exit 22
fi
echo "$(cat /tmp/${FILE}.sha256) /tmp/${FILE}" | sha256sum -c || exit 23
rm /tmp/${FILE}.sha256

echo "Unzip $ISSUER ${ISSUER_VERSION}..."
tar -xf /tmp/$FILE -C /opt
if test $? -ne 0; then
 echo "Unzip $ISSUER $ISSUER_VERSION error!"; exit 31
fi
rm /tmp/$FILE

echo "Running $ISSUER ${ISSUER_VERSION}..."
/opt/jdk-${ISSUER_VERSION}/bin/java --version
if test $? -ne 0; then
 echo "Running $ISSUER $ISSUER_VERSION error!"; exit 41
fi
