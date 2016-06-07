#!/bin/sh

# Utilities for CorfuDB server management

corfu_fmt_sequencer_cmd () {
    corfu_fmt_cmd sequencer "$1"
}

corfu_fmt_layout_cmd () {
    corfu_fmt_cmd layout "$1"
}

corfu_fmt_log_cmd () {
    corfu_fmt_cmd log "$1"
}

corfu_fmt_log_path () {
    c_type="$1"
    idx="$2"
    echo "$CORFU_LOG_PREFIX/${c_type}.${idx}"
}

corfu_fmt_console_path () {
    c_type="$1"
    idx="$2"
    echo "$CORFU_CONSOLE_PREFIX/${c_type}.${idx}"
}

corfu_fmt_pid_path () {
    c_type="$1"
    idx="$2"
    echo "$CORFU_PID_PREFIX/${c_type}.${idx}"
}

corfu_fmt_cmd () {
    c_type="$1"
    idx="$2"
    case $c_type in
	sequencer)
	    type_str="echo \$CORFU_SEQUENCER_TYPE_${idx}"
	    host_str="echo \$CORFU_SEQUENCER_HOST_${idx}"
	    port_str="echo \$CORFU_SEQUENCER_PORT_${idx}"
	    debug_str="echo \$CORFU_SEQUENCER_DEBUG_${idx}"
	    ;;
	layout)
	    type_str="echo \$CORFU_LAYOUT_TYPE_${idx}"
	    host_str="echo \$CORFU_LAYOUT_HOST_${idx}"
	    port_str="echo \$CORFU_LAYOUT_PORT_${idx}"
	    debug_str="echo \$CORFU_LAYOUT_DEBUG_${idx}"
	    ;;
	log)
	    type_str="echo \$CORFU_LOG_TYPE_${idx}"
	    host_str="echo \$CORFU_LOG_HOST_${idx}"
	    port_str="echo \$CORFU_LOG_PORT_${idx}"
	    debug_str="echo \$CORFU_LOG_DEBUG_${idx}"
	    ;;
	*)
	    echo "Unknown c_type: $c_type"
	    exit 1
    esac

    CORFU_CMD="$CORFU_SRC_DIR/bin/corfu_server -l %s -a %s -t -1 -d %s %s"
    type=`eval $type_str`
    if [ -z "$type" ]; then
	# No configuration is available for this type + idx.  Perhaps
	# idx=0 but the config doesn't define any servers for this
	# type/role?  Let's do nothing by returning something harmless.
	echo /bin/true
    elif [ $type = memory ]; then
	echo TODO: memory type printf
    else
	log_path=`corfu_fmt_log_path ${c_type} ${idx}`
	mkdir -p `dirname $log_path`
	printf "$CORFU_CMD" "$log_path" `eval $host_str` \
	       `eval $debug_str` `eval $port_str`
    fi
}

corfu_max_type_idx () {
    c_type="$1"
    i=-1
    go=yes

    # The only kludge that comes to mind right now {sigh}.  Look away.
    case $c_type in
	sequencer)
	    base=CORFU_SEQUENCER_PORT_
	    ;;
	layout)
	    base=CORFU_LAYOUT_PORT_
	    ;;
	log)
	    base=CORFU_LOG_PORT_
	    ;;
	*)
	    echo "Unknown c_type: $c_type"
	    exit 1
    esac
    while [ ! -z $go ]; do
	j=`expr $i + 1`
	tmp1="echo \$${base}${j}"
	go=`eval $tmp1`
	if [ -z "$go" ]; then
	    echo $i
	fi
	i=`expr $i + 1`
    done
}

join_str () {
    mid_string=$1
    shift

    while [ $# -gt 0 ]; do
	/bin/echo -n $1
	if [ $# -ne 1 ]; then
	    /bin/echo -n "$mid_string"
	fi
	shift
    done
}
