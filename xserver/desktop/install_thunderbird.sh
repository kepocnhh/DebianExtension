#!/bin/bash

ISSUER=thunderbird

LATEST_VERSIONS="$(curl -s --max-time 2 https://ftp.mozilla.org/pub/thunderbird/releases/ \
 | grep '/releases/' \
 | grep -Po '(?<=/releases/)[1-9]([0-9]|\.)+[0-9](?=/">)' \
 | sort -V | tail -n 16)"
if test $? -ne 0; then
 echo "Get latest versions $ISSUER error!"; exit 11
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions $ISSUER is empty!"; exit 12
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

DISTRIBUTION="linux-$(/usr/bin/uname -m)"
LANGUAGE='en-US'

for it in ISSUER_VERSION DISTRIBUTION LANGUAGE; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 22; fi; done

if test -d "/opt/mozilla/${ISSUER}-$ISSUER_VERSION"; then
 echo "${ISSUER^} $ISSUER_VERSION exists!"; exit 23
fi

case "$DISTRIBUTION" in
 'linux-x86_64') /bin/true;; # ignored
 *) echo "Distribution $DISTRIBUTION is not supported!"; exit 31;;
esac

case "$LANGUAGE" in
 'en-US') /bin/true;; # ignored
 *) echo "Distribution $DISTRIBUTION is not supported!"; exit 32;;
esac

BASE_URL="https://ftp.mozilla.org/pub/thunderbird/releases/$ISSUER_VERSION"

echo "Download $ISSUER key..."
FILE="${ISSUER}-pub.gpg"
rm /tmp/$FILE
curl -f "$BASE_URL/KEY" -o /tmp/$FILE && gpg --import /tmp/$FILE || exit 51
rm /tmp/$FILE

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="thunderbird-${ISSUER_VERSION}.tar.bz2"
rm /tmp/$FILE
curl -f "$BASE_URL/$DISTRIBUTION/$LANGUAGE/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION error!"; exit 52
fi

echo "Download $ISSUER $ISSUER_VERSION signature..."
rm /tmp/${FILE}.asc
curl -f "$BASE_URL/$DISTRIBUTION/$LANGUAGE/${FILE}.asc" -o /tmp/${FILE}.asc
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION signature error!"; exit 53
fi

gpg --verify /tmp/${FILE}.asc /tmp/$FILE || exit 61
rm /tmp/${FILE}.asc

echo "Unzip $ISSUER ${ISSUER_VERSION}..."
rm -rf /tmp/$ISSUER
tar -xf /tmp/$FILE -C /tmp
if test $? -ne 0; then
 echo "Unzip $ISSUER $ISSUER_VERSION error!"; exit 71
fi

echo "Install $ISSUER ${ISSUER_VERSION}..."
if [ ! -d "/opt/mozilla" ]; then
 mkdir "/opt/mozilla" || exit 72 # todo
fi
mv /tmp/$ISSUER "/opt/mozilla/${ISSUER}-$ISSUER_VERSION"
if test $? -ne 0; then
 echo "Install $ISSUER $ISSUER_VERSION error!"; exit 81
fi
rm /tmp/$FILE
