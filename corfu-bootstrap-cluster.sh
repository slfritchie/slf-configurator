#!/bin/sh

env="$1"

source corfu-cluster.sh
source $env

## Creating a JSON object with the Bourne shell.  What could go wrong?

acc=""
max=`corfu_max_type_idx sequencer`
i=0
while [ $i -le $max ]; do
    host_str="echo \$CORFU_SEQUENCER_HOST_${i}" ; host=`eval $host_str`
    port_str="echo \$CORFU_SEQUENCER_PORT_${i}" ; port=`eval $port_str`
    acc="$acc `printf '\"%s:%s\"' $host $port`"
    i=`expr $i + 1`
done
res=`echo $acc`
sequencer_addresses=`join_str ", " $res`

acc=""
max=`corfu_max_type_idx layout`
i=0
while [ $i -le $max ]; do
    host_str="echo \$CORFU_LAYOUT_HOST_${i}" ; host=`eval $host_str`
    port_str="echo \$CORFU_LAYOUT_PORT_${i}" ; port=`eval $port_str`
    acc="$acc `printf '\"%s:%s\"' $host $port`"
    i=`expr $i + 1`
done
res=`echo $acc`
layout_addresses=`join_str ", " $res`

acc=""
max=`corfu_max_type_idx log`
i=0
while [ $i -le $max ]; do
    host_str="echo \$CORFU_LOG_HOST_${i}" ; host=`eval $host_str`
    port_str="echo \$CORFU_LOG_PORT_${i}" ; port=`eval $port_str`
    acc="$acc `printf '\"%s:%s\"' $host $port`"
    i=`expr $i + 1`
done
res=`echo $acc`
log_addresses=`join_str ", " $res`

bootstrap_config=`mktemp /tmp/corfu-bootstrap-config.XXXXXXXXX`
trap "rm -f $bootstrap_config" 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15

cat<<! > $bootstrap_config
{
    "layoutServers": [ $layout_addresses ],
    "sequencers": [ $sequencer_addresses ],
    "segments": [
	{
	    "replicationMode": "CHAIN_REPLICATION",
	    "start": 0,
	     "end": -1,
	     "stripes": [
		 {
		     "logServers": [ $log_addresses ]
		 }
	     ]}],
    "epoch": 2
}
!

errors=0
for addr in `echo $sequencer_addresses $layout_addresses \
                  $log_addresses | sed 's/[,"]//g'`; do
    /bin/echo -n "Corfu server address $addr: "
    ## Boo, the cmdlet thingie does not alter its exit status............
    res=`$CORFU_SRC_DIR/bin/corfu_layout corfu_layout bootstrap \
    				    -l $bootstrap_config $addr 2>&1`
    echo "$res"
    echo "$res" | grep -q NACK
    if [ $? -eq 0 ]; then
    	errors=`expr $errors + 1`
    fi
done

if [ $errors -eq 0 ]; then
    echo "Bootstrap successful"
    exit 0
else
    echo "ERROR: bootstrap failed on $errors hosts"
    exit 1
fi
