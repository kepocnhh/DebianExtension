#!/bin/bash

ISSUER=ranger

for it in PYTHON_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

LATEST_VERSIONS="$(https://api.github.com/repos/ranger/ranger/git/refs/tags \
 | jq -r .[].ref | grep -Po '(?<=refs/tags/v)[1-9].[0-9]\S+' \
 | sort -V | tail -n 16)"
if test $? -ne 0; then
 echo "Get latest versions $ISSUER error!"; exit 12
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions $ISSUER is empty!"; exit 13
fi

ISSUER_VERSION=""
echo "
Latest version: $LATEST_VERSION

Enter $ISSUER version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  RANGER_VERSION+=$char
 fi
done

if test -d "/opt/ranger-$ISSUER_VERSION"; then
 echo "${ISSUER^} ${ISSUER_VERSION} exists!"; exit 23
fi

apt-get install --no-install-recommends -y file
if test $? -ne 0; then
 echo "Install lib error!"; exit 31
fi

gpg --keyserver pgp.mit.edu --recv-keys '1E9B36EC051FF6F7FFC969A7F08CE1E200FB5CDF'
if test $? -ne 0; then
 echo "Import $ISSUER public key error!"; exit 42
fi

BASE_URL=https://ranger.github.io

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="ranger-${ISSUER_VERSION}.tar.gz"
rm /tmp/$FILE
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION error!"; exit 42
fi

echo "Download $ISSUER $ISSUER_VERSION signature..."
rm /tmp/${FILE}.asc
curl -f "$BASE_URL/${FILE}.sig" -o /tmp/${FILE}.sig
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION signature error!"; exit 43
fi

gpg --verify /tmp/${FILE}.sig /tmp/$FILE || exit 44
rm /tmp/${FILE}.sig

exit 1 # todo

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
