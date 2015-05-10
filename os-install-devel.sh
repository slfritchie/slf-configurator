#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO installing XCode and XCode command line utilities?
    ;;
    ubuntu)
        # See also: https://github.com/gordonguthrie/vagrant-riak.2.0.2-ubuntu-trusty-x64_86/blob/master/provision-riak-2.0.2.vagrant
        apt-get install -y \
            build-essential \
            git git-core
    ;;
    centos)
        yum install -y \
	    make gcc gcc-c++ kernel-devel m4 \
            git
    ;;
    freebsd)
        ## WEIRD: 'pkg' install of gcc doesn't have 'gcc' executable anywhere?
        env ASSUME_ALWAYS_YES=yes pkg install -f \
            clang36 m4 autoconf autotools \
            git gmake
    ;;
    smartos)
        pkgin -y install gcc47 m4 autoconf \
            git-base gmake
    ;;
esac

exit 0
