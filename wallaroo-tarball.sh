#!/bin/sh

## Prerequisites:
##
## 1. All Wallaroo toolchain stuff has already been installed by
##    ALL-wallaroo-dev.sh.
## 2. All optional Wallaroo toolchain stuff (e.g. Elixir) has been installed.

REPO_DIR=${WALLAROO_REPO:-/tmp/wallaroo}
BRANCH=${WALLAROO_BRANCH:-master}
TARBALL_DIR=${TARBALL_DIR:-/tmp/tarball}

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

(
    cd monitoring_hub
    export PATH=/usr/local/erlang/19.3/bin:/usr/local/elixir/v1.2.6/bin:$PATH
    mix local.hex --force
    mix local.rebar --force
cat <<EOF
    ## This !@#$!%! is broken / I'm not sure how the hell it might work........
    env MIX_ENV=prod mix deps.clean --all
    env MIX_ENV=prod mix deps.get --only prod
    env MIX_ENV=prod mix compile
    (
        cd apps/metrics_reporter_ui
        npm install
        npm run build:production
    )
    env MIX_ENV=prod mix phoenix.digest
    env MIX_ENV=prod mix release.clean
    env MIX_ENV=prod mix release
EOF
) 

## Start tarball work

rm -rf $TARBALL_DIR
for dir in bin lib lib-extra; do
    mkdir -p $TARBALL_DIR/$dir
done

cp -p giles/receiver/receiver $TARBALL_DIR/bin
cp -p giles/sender/sender $TARBALL_DIR/bin
cp -p machida/build/machida $TARBALL_DIR/bin
cp -p utils/cluster_shutdown/cluster_shutdown $TARBALL_DIR/bin

# Assume Linux here, derp......

for lib in `ldd $TARBALL_DIR/bin/* | awk '{print $3}' | grep -v 0x00 | sort -u`
do
    cp -p $lib $TARBALL_DIR/lib-extra
done

exit 0
