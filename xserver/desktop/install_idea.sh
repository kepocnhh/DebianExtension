#!/bin/bash

for it in JAVA_HOME GRADLE_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 22; fi; done

ISSUER=idea

LATEST_VERSIONS="$(curl -s --max-time 2 https://blog.jetbrains.com/idea/category/releases/ \
 | grep '<h3>IntelliJ IDEA' \
 | grep -Po '(?<=IDEA )\S+(?= (I|i)s )' \
 | sort -V)"
if test $? -ne 0; then
 echo "Get latest versions $ISSUER error!"; exit 12
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions $ISSUER is empty!"; exit 13
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

for it in ISSUER_VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

if test -d "/opt/jetbrains/idea-$ISSUER_VERSION"; then
 echo "${ISSUER^} $ISSUER_VERSION exists!"; exit 22
fi

BASE_URL="https://download.jetbrains.com/idea"

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="ideaIC-${ISSUER_VERSION}.tar.gz"
rm /tmp/$FILE
curl -f -L "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION error!"; exit 31
fi

echo "Download $ISSUER $ISSUER_VERSION checksum..."
rm /tmp/${FILE}.sha256
curl -f "$BASE_URL/${FILE}.sha256" -o /tmp/${FILE}.sha256
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION checksum error!"; exit 32
fi
echo "$(cat /tmp/${FILE}.sha256 | cut -d ' ' -f 1) /tmp/$FILE" | sha256sum -c || exit 33
rm /tmp/${FILE}.sha256

echo "Unzip $ISSUER ${ISSUER_VERSION}..."
rm -rf /tmp/idea-IC-*
tar -xf /tmp/$FILE -C /tmp
if test $? -ne 0; then
 echo "Unzip $ISSUER $ISSUER_VERSION error!"; exit 41
fi

echo "Install $ISSUER ${ISSUER_VERSION}..."
if [ ! -d "/opt/jetbrains" ]; then
 mkdir "/opt/jetbrains" || exit 1 # todo
fi
mv /tmp/idea-IC-* "/opt/jetbrains/idea-${ISSUER_VERSION}"
if test $? -ne 0; then
 echo "Install $ISSUER $ISSUER_VERSION error!"; exit 42
fi
rm /tmp/$FILE
