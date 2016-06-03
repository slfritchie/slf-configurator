#!/bin/sh

env="$1"

source corfu-cluster.sh
source $env

for type in sequencer layout log; do
    max=`corfu_max_type_idx $type`
    for i in `seq 0 $max`; do
	corfu-start-server.sh $env $type $i
    done
done
