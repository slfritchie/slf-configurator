#!/bin/sh

. ./base.env

. ./setup-usr-local-src.sh

# For Linux systems with SystemTap, use the 1st line instead of the 2nd line.
##CONFIG_STAP="--enable-vm-probes --with-dynamic-trace=systemtap"
CONFIG_STAP=""

BASHO_OTP_TAG=OTP_R16B02_basho8
OTP_VERSION=R16B02
OTP_PREFIX=/usr/local/erlang/$OTP_VERSION

CLONE_URL=https://github.com/basho/otp.git

if [ ! -f /usr/local/src/otp ]; then
    cd /usr/local/src
    git clone https://github.com/basho/otp.git
fi

(  ## subshell until end of script

cd /usr/local/src/otp
git checkout -f $BASHO_OTP_TAG

case $OS_DISTRO in
    osx)
        OTP_MAKE=make
        CONFIG_ARGS="--prefix=$OTP_PREFIX --enable-darwin-64bit --with-cocoa \
                     --enable-smp-support --enable-hipe --enable-threads \
                     --enable-kernel-poll --without-javac \
                     --without-odbc --with-ssl \
                     --enable-vm-probes --with-dynamic-trace=dtrace"
        OTP_CFLAGS='-arch x86_64 -march=native -m64 -O3'
        OTP_CFLAGS+=' -Wno-deprecated-declarations'
        OTP_CFLAGS+=' -Wno-empty-body'
        OTP_CFLAGS+=' -Wno-implicit-function-declaration'
        OTP_CFLAGS+=' -Wno-parentheses-equality'
        OTP_CFLAGS+=' -Wno-pointer-sign'
        OTP_CFLAGS+=' -Wno-tentative-definition-incomplete-type'
        OTP_CFLAGS+=' -Wno-unused-function'
        OTP_CFLAGS+=' -Wno-unused-value'
        OTP_CFLAGS+=' -Wno-unused-variable'
        OTP_CXXFLAGS="$OTP_CFLAGS"
        OTP_LDFLAGS='-O4'
    ;;
    ubuntu)
        OTP_MAKE=make
        CONFIG_ARGS="--prefix=$OTP_PREFIX --enable-m64-build \
                     --enable-smp-support --enable-hipe --enable-threads \
                     --enable-kernel-poll --without-javac \
                     --without-odbc --with-ssl \
                     $CONFIG_STAP"
        OTP_CFLAGS=''
        OTP_CXXFLAGS="$OTP_CFLAGS"
        OTP_LDFLAGS=''
    ;;
    centos)
        OTP_MAKE=make
        CONFIG_ARGS="--prefix=$OTP_PREFIX --enable-m64-build \
                     --enable-smp-support --enable-hipe --enable-threads \
                     --enable-kernel-poll --without-javac \
                     --without-odbc --with-ssl \
                     $CONFIG_STAP"
    ;;
    freebsd)
        /sbin/kldload -n dtraceall
        OTP_MAKE=gmake
        CONFIG_ARGS="--prefix=$OTP_PREFIX --enable-m64-build --with-cocoa \
                     --enable-smp-support --enable-hipe --enable-threads \
                     --enable-kernel-poll --without-javac \
                     --without-odbc --with-ssl \
                     --enable-vm-probes --with-dynamic-trace=dtrace"
    ;;
esac

./otp_build autoconf && \
env "CFLAGS=$OTP_CFLAGS" "CXXFLAGS=$OTP_CXXFLAGS" "LDFLAGS=$OTP_LDFLAGS" \
    ./configure $CONFIG_ARGS && \
    $OTP_MAKE -j8 && $OTP_MAKE install && $OTP_MAKE clean && exit 0

exit 1

)  ## end of subshell

