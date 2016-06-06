#!/bin/sh

env="$1"

source $env
source corfu-cluster.sh

for type in sequencer layout log; do
    max=`corfu_max_type_idx $type`
    for i in `seq 0 $max`; do
	corfu-delete-console-dir.sh $env $type $i
    done
done
