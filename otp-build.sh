#!/bin/sh

. ./base.env

. ./setup-usr-local-src.sh

# For Linux systems with SystemTap, use the 1st line instead of the 2nd line.
##CONFIG_STAP="--enable-vm-probes --with-dynamic-trace=systemtap"
CONFIG_STAP=""

OTP_VERSION=17.5
#OTP_SRC=http://www.erlang.org/download/otp_src_17.5.tar.gz
OTP_SRC=http://slfritchie-jp.s3.amazonaws.com/cache/otp_src_17.5.tar.gz
OTP_MAN=http://www.erlang.org/download/otp_doc_man_17.5.tar.gz
OTP_HTML=http://www.erlang.org/download/otp_doc_html_17.5.tar.gz

OTP_PREFIX=/usr/local/erlang/$OTP_VERSION
TARBALL=`basename $OTP_SRC`
SRCBASE=`basename $TARBALL .tar.gz`

if [ ! -f /usr/local/src/$TARBALL ]; then
    (cd /usr/local/src/tmp ; wget --tries=10 $OTP_SRC && mv $TARBALL ..)
fi

BDIR=/usr/local/src/build
OTP_TOP=$BDIR/$SRCBASE
mkdir -p $BDIR

(  ## subshell until end of script

cd /usr/local/src/build ; rm -rf $SRCBASE ; tar zxf /usr/local/src/$TARBALL
cd $SRCBASE 

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
        CONFIG_ARGS="--prefix=$OTP_PREFIX --enable-m64-build  \
                     --enable-smp-support --enable-hipe --enable-threads \
                     --enable-kernel-poll --without-javac \
                     --without-odbc --with-ssl \
                     --enable-vm-probes --with-dynamic-trace=dtrace"
    ;;
    omnios)
        PATH=/usr/css/bin:${PATH}:/opt/gcc-4.8.1/bin
        export PATH

        OTP_MAKE=gmake
        CONFIG_ARGS="--prefix=$OTP_PREFIX --enable-m64-build \
                     --enable-smp-support --enable-hipe --enable-threads \
                     --enable-kernel-poll --without-javac \
                     --without-odbc --with-ssl \
                     --enable-vm-probes --with-dynamic-trace=dtrace"
    ;;
    smartos)
        OTP_MAKE=gmake
        CONFIG_ARGS="--prefix=$OTP_PREFIX --enable-m64-build \
                     --enable-smp-support --enable-hipe --enable-threads \
                     --enable-kernel-poll --without-javac \
                     --without-odbc --with-ssl \
                     --enable-vm-probes --with-dynamic-trace=dtrace"
    ;;
esac

env "CFLAGS=$OTP_CFLAGS" "CXXFLAGS=$OTP_CXXFLAGS" "LDFLAGS=$OTP_LDFLAGS" \
    ./configure $CONFIG_ARGS && \
    $OTP_MAKE -j8 && $OTP_MAKE install && \
    cd .. && rm -rf $SRCBASE && exit 0

exit 1

)  ## end of subshell

