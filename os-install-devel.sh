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
        # But the liblz4-dev package sucks, so deal with that later.
        sudo apt-get install -y libsnappy-dev python-pip python-dev
        sudo apt-get install -y python3-dev python3-pip
        sudo pip3 install virtualenv
        sudo pip3 install pytest

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

        # Compile liblz4 from scratch
        (
         mkdir -p /usr/local/src
         cd /usr/local/src
         git clone https://github.com/lz4/lz4.git
         cd lz4
         make
         make install
        )
    ;;
    centos)
        yum install -y \
	    make gcc gcc-c++ kernel-devel m4 \
            git expect patch

        echo 'Installing LLVM 3.7.1 or 3.8.1 or 3.9.1 for use'
        echo 'with Pony development is *extremely* difficult on CentOS 7.'
        echo "SKIPPING installing any LLVM."

# NOTE: This recipe will work, but it takes *hours* to compile on a
# modest virtual machine.....
#
#        mkdir /root/llvm
#        (
#            cd /root/llvm
#            wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#            rpm -ivh epel-release-latest-7.noarch.rpm
#            yum install -y \
#                llvm3.9 llvm3.9-devel llvm3.9-libs llvm3.9-static
#
#            echo BAH, the above does not work either
#            ### http://www.linuxfromscratch.org/blfs/view/7.9/general/llvm.html
#
#            yum install -y \
#                libffi libffi-devel
#            wget http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz
#            wget http://llvm.org/releases/3.7.1/cfe-3.7.1.src.tar.xz
#            wget http://llvm.org/releases/3.7.1/compiler-rt-3.7.1.src.tar.xz
#            unxz -c < llvm-3.7.1.src.tar.xz | tar xf -
#            (
#                cd llvm-3.7.1.src
#                tar -xf ../cfe-3.7.1.src.tar.xz -C tools &&
#                    tar -xf ../compiler-rt-3.7.1.src.tar.xz -C projects &&
#                    mv tools/cfe-3.7.1.src tools/clang &&
#                    mv projects/compiler-rt-3.7.1.src projects/compiler-rt
#                sed -r "/ifeq.*CompilerTargetArch/s#i386#i686#g" \
#                    -i projects/compiler-rt/make/platform/clang_linux.mk
#
#                sed -e "s:/docs/llvm:/share/doc/llvm-3.7.1:" \
#                    -i Makefile.config.in &&
#                    mkdir -v build &&
#                    cd       build &&
#                    CC=gcc CXX=g++                          \
#                      ../configure --prefix=/usr/local      \
#                      --datarootdir=/usr/local/share   \
#                      --sysconfdir=/etc          \
#                      --enable-libffi            \
#                      --enable-optimized         \
#                      --enable-shared            \
#                      --enable-targets=host,r600 \
#                      --disable-assertions       \
#                      --docdir=/usr/local/share/doc/llvm-3.7.1 &&
#                    make
#                make install &&
#                    for file in /usr/local/lib/lib{clang,LLVM,LTO}*.a
#                    do
#                        test -f $file && chmod -v 644 $file
#                    done
#                unset file
#            )
#        )
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
