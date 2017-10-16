#!/bin/sh

./os-install-essentials.sh && \
    ./os-install-devel.sh && \
    ./ponylang-ponyc.sh && \
    ./os-install-docker.sh && \
    exit 0

exit 1
