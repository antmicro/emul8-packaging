#!/bin/bash

set -e

if [[ -z $1 ]]
then
    echo "Usage: $0 path-to-emul8-dir"
    exit 1
fi
set -u

OUT_FILE=emul8-bundle
BUILD_DIR=/tmp/emul8_bundle
rm -r $BUILD_DIR || true
mkdir -p $BUILD_DIR

EMUL_DIR=$1
pushd $EMUL_DIR >/dev/null

./bootstrap.sh -a
./build.sh

cp -r output/Release/* $BUILD_DIR
cp .emul8root $BUILD_DIR
cp LICENSE $BUILD_DIR
cp README.rst $BUILD_DIR
cp -r platforms/ scripts/ $BUILD_DIR
cp RobotFrontend/*robot $BUILD_DIR
popd >/dev/null

CUR_DIR=`pwd`
pushd $BUILD_DIR >/dev/null
cd ..
tar -cvvf ${OUT_FILE}.tar `basename $BUILD_DIR`
gzip -f ${OUT_FILE}.tar

cp ${OUT_FILE}.tar.gz $CUR_DIR

popd >/dev/null

echo "Bundle successfully created in ${OUT_FILE}.tar.gz"
