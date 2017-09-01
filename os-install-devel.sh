#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO installing XCode and XCode command line utilities?
    ;;
    ubuntu)
        grep -s llvm-toolchain-xenial-3.9 /etc/apt/sources.list
        if [ $? -ne 0 ]; then
            cat <<EOF >> /etc/apt/sources.list
deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main
EOF
            cd /tmp
            wget -O llvm-snapshot.gpg.key http://apt.llvm.org/llvm-snapshot.gpg.key
            sudo apt-key add llvm-snapshot.gpg.key
            apt-get update
        fi

        # Sendence's ponyc & Wallaroo requires gcc 5 for its atomics support
	sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
        sudo apt-get update
        sudo apt-get install -y gcc-5 g++-5
        sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
        # Also need snappy and lz4 and pip & virtualenv & python-dev
        sudo apt-get install libsnappy-dev liblz4-dev python-pip python-dev
        sudo pip install virtualenv

        # See also: https://github.com/gordonguthrie/vagrant-riak.2.0.2-ubuntu-trusty-x64_86/blob/master/provision-riak-2.0.2.vagrant
        apt-get install -y \
            build-essential \
            git git-core expect \
            zlib1g-dev libncurses5-dev libssl-dev llvm-3.9

        # Ubuntu 14/trusty doesn't have a package for pcre2
        apt-get install -y libpcre2-dev
        if [ $? -ne 0 ]; then
            (
                cd /tmp
                wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.21.tar.bz2
                tar xjvf pcre2-10.21.tar.bz2
                cd pcre2-10.21
                ./configure --prefix=/usr
                make
                sudo make install
            )
        fi
    ;;
    centos)
        yum install -y \
	    make gcc gcc-c++ kernel-devel m4 \
            git expect patch
    ;;
    freebsd)
        ## WEIRD: 'pkg' install of gcc doesn't have 'gcc' executable anywhere?
        env ASSUME_ALWAYS_YES=yes pkg install -f \
            llvm39 libunwind pcre2 \
	    m4 autoconf autotools \
            git gmake expect
    ;;
    smartos)
        pkgin -y install gcc47 m4 autoconf \
            git-base gmake expect
    ;;
esac

exit 0
