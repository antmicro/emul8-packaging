#!/bin/bash

set -e

if [[ -z $1 ]] || [[ -z $2 ]]
then
    echo "Usage: $0 path-to-mono-source-dir path-to-gtk-sharp-source-dir"
    exit 1
fi
set -u

BUILD_DIR=`pwd`/mono-build

rm -r $BUILD_DIR 2>/dev/null || true
mkdir -p $BUILD_DIR

MONO_DIR=$1
GTK_DIR=$2

pushd $MONO_DIR >/dev/null

./autogen.sh --prefix=$BUILD_DIR
make -j9
make install

cp LICENSE $BUILD_DIR/LICENSE_MONO

popd >/dev/null

pushd $GTK_DIR >/dev/null

./configure --prefix=$BUILD_DIR
make
make install

cp COPYING $BUILD_DIR/LICENSE_GTK_SHARP

popd >/dev/null

tar -cvvf ${BUILD_DIR}.tar `basename $BUILD_DIR` mono-env
gzip -f ${BUILD_DIR}.tar

echo "Mono and gtk-sharp bundle successfully created in ${BUILD_DIR}.tar.gz"
