#!/bin/bash

if test $# -ne 2; then
  echo "Script needs for 2 arguments but actual $#!"; exit 11
fi

DOCKER_VERSION=$1
ARCHITECTURE=$2

for it in DOCKER_VERSION ARCHITECTURE; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

if test -d "/opt/docker-$DOCKER_VERSION"; then
 echo "Docker $DOCKER_VERSION exists!"; exit 22
fi

BASE_URL=https://download.docker.com/linux/static/stable/$ARCHITECTURE

echo "Download docker ${DOCKER_VERSION}..."
FILE="docker-${DOCKER_VERSION}.tgz"
rm /tmp/$FILE
curl -f -L "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download docker $DOCKER_VERSION error!"; exit 31
fi

echo "Download docker rootless extras ${DOCKER_VERSION}..."
FILE="docker-rootless-extras-${DOCKER_VERSION}.tgz"
rm /tmp/$FILE
curl -f -L "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download docker rootless extras $DOCKER_VERSION error!"; exit 32
fi

echo "Unzip docker ${DOCKER_VERSION}..."
mkdir -p /opt/docker-$DOCKER_VERSION
rm -rf /tmp/docker

FILE="docker-${DOCKER_VERSION}.tgz"
tar -xf /tmp/$FILE -C /tmp
if test $? -ne 0; then
 echo "Unzip docker $DOCKER_VERSION error!"; exit 41
fi
rm /tmp/$FILE
mv /tmp/docker/* "/opt/docker-${DOCKER_VERSION}/"
if test $? -ne 0; then
 echo "Install docker $DOCKER_VERSION error!"; exit 42
fi

FILE="docker-rootless-extras-${DOCKER_VERSION}.tgz"
tar -xf /tmp/$FILE -C /tmp
if test $? -ne 0; then
 echo "Unzip docker rootless extras $DOCKER_VERSION error!"; exit 43
fi
rm /tmp/$FILE
mv /tmp/docker-rootless-extras/* "/opt/docker-${DOCKER_VERSION}/"
if test $? -ne 0; then
 echo "Install docker rootless extras $DOCKER_VERSION error!"; exit 44
fi

echo "Running docker ${DOCKER_VERSION}..."
/opt/docker-${DOCKER_VERSION}/containerd --version \
 && /opt/docker-${DOCKER_VERSION}/dockerd --version
if test $? -ne 0; then
 echo "Running docker $DOCKER_VERSION error!"; exit 51
fi

exit 0
