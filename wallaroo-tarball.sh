#!/bin/sh

## Prerequisites:
##
## 1. All Wallaroo toolchain stuff has already been installed by
##    ALL-wallaroo-dev.sh.
## 2. All optional Wallaroo tollchain stuff (e.g. Elixir) has been installed.

REPO_DIR=${WALLAROO_REPO:-/tmp/wallaroo}
BRANCH=${WALLAROO_BRANCH:-master}
TARBALL_DIR=/tmp/tarball

. ./base.env

## TODO? Move the actual compilation/make stuff to a separate script?

if [ ! -d $REPO_DIR ]; then
    cd `dirname $REPO_DIR`
    git clone https://github.com/WallarooLabs/wallaroo
fi

WALLAROO_BUILD_SUBDIRS="machida giles/sender giles/receiver utils/cluster_shutdown"

cd $REPO_DIR
git checkout -f $BRANCH

for target in $WALLAROO_BUILD_SUBDIRS; do
    ( cd $target ; make)
done

## Start tarball work

rm -rf $TARBALL_DIR
for dir in bin lib; do
    mkdir -p $TARBALL_DIR/$dir
done

cp -p giles/receiver/receiver $TARBALL_DIR/bin
cp -p giles/sender/sender $TARBALL_DIR/bin
cp -p machida/build/machida $TARBALL_DIR/bin
cp -p utils/cluster_shutdown/cluster_shutdown $TARBALL_DIR/bin

exit 0
