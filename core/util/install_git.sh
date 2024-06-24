#!/bin/bash

apt-get install --no-install-recommends -y git || exit 21
/usr/bin/git config --global credential.helper store || exit 22

git --version || exit 23
