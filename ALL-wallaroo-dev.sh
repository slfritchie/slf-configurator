#!/bin/sh

./os-install-essentials.sh && \
    ./os-install-devel.sh && \
    ./ponylang-ponyc.sh && \
    ./ponylang-stable.sh && \
    ./ponylang-Sendence.sh && \
    exit 0

exit 1
