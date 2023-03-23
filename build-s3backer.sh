#!/usr/bin/env bash

mkdir -p /build
cd /build
git clone --depth=1 --branch "2.0.2" https://github.com/archiecobbs/s3backer.git .

./cleanup.sh
mkdir -p m4
autoreconf -iv

./configure --enable-assertions
make
make install


