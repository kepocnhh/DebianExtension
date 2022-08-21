#!/bin/bash

for it in DEBIAN_EXTENSION_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ISSUER=python

LATEST_VERSIONS="$(curl -s --max-time 2 https://www.python.org/ftp/python/ \
 | grep -E '^<a href="[1-9].[0-9]' \
 | grep -Po '(?<=<a href=")[1-9].[0-9]+(.[0-9]+)?' \
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

if test -d "/opt/Python-$ISSUER_VERSION"; then
 echo "${ISSUER^} $ISSUER_VERSION exists!"; exit 22
fi

docker stop python$ISSUER_VERSION
docker rm python$ISSUER_VERSION
docker build \
 --build-arg PYTHON_VERSION=$ISSUER_VERSION \
 -f=$DEBIAN_EXTENSION_HOME/core/util/python/Dockerfile \
 -t=python:$ISSUER_VERSION $DEBIAN_EXTENSION_HOME/core/util/python/ \
 && docker run --name=python$ISSUER_VERSION python:$ISSUER_VERSION \
 && docker cp python$ISSUER_VERSION:/opt/Python-$ISSUER_VERSION /opt/ \
 && docker stop python$ISSUER_VERSION && docker rm python$ISSUER_VERSION

/opt/Python-${ISSUER_VERSION}/python --version
if test $? -ne 0; then
 echo "Running $ISSUER $ISSUER_VERSION error!"; exit 31
fi
