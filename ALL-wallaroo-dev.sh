#!/bin/sh

./os-install-essentials.sh && \
    ./os-install-devel.sh && \
    ./ponylang-ponyc.sh && \
    ./docker-install.sh && \
    exit 0

exit 1
