#!/bin/sh

./os-install-essentials.sh && \
    ./os-install-devel.sh && \
    ./os-install-devel-otp.sh && \
    ./otp-build.sh && \
    exit 0

exit 1
