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

# Let's try some Python relocation hackery now.
# Data from:
# sudo strace -f -o /tmp/foofoo env PATH="$PATH:$HOME/wallaroo/machida/build" PYTHONPATH="$PYTHONPATH:.:$HOME/wallaroo/machida" machida --application-module alphabet --in 127.0.0.1:7010   --out 127.0.0.1:7002 --metrics 127.0.0.1:5001 --control 127.0.0.1:6000   --external 127.0.0.1:5050 --cluster-initializer --data 127.0.0.1:6001   --name worker-name --ponythreads=1 --ponynoblock

(cd /usr/lib ; tar cf - ./python2.7) | (cd $TARBALL_DIR/lib ; tar xf -)
(cd /usr/bin ; tar cf - ./python2*) | (cd $TARBALL_DIR/bin ; tar xfp -)
# Weird, avoid startup errors not finding _sysconfigdata_nd in its
# usual (?) location in the /usr/lib/python2.7/plat-x86_64-linux-gnu dir.
(cd $TARBALL_DIR/lib/python2.7 ; ln -s */_sysconfigdata_nd.py .)
(cd $TARBALL_DIR/lib/python2.7 ; ln -s */_sysconfigdata_nd.pyc .)

exit 0

# Sweet.
# Machida runs When using:
#
# 1. Tarball created by this script, copied to a bare-bones Ubuntu 14.04
#    container/VM/thingie with zero Python v2 or compiler toolchain installed
#    in our new thingie.
# 2. Tarball of /apps extracted from the Docker container image
#    sendence/wallaroo-metrics-ui:0.1, extracted to /apps in our new thingie.
# 3. The command below:
#
# env LD_LIBRARY_PATH=/tmp/tarball/lib-extra PATH="$PATH:/tmp/tarball/bin" PYTHONPATH="/tmp/tarball/lib/python2.7:/tmp/wallaroo/machida:." machida --application-module alphabet --in 127.0.0.1:7010   --out 127.0.0.1:7002 --metrics 127.0.0.1:5001 --control 127.0.0.1:6000   --external 127.0.0.1:5050 --cluster-initializer --data 127.0.0.1:6001   --name worker-name --ponythreads=1 --ponynoblock
