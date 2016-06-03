#!/bin/sh

corfu_fmt_sequencer_cmd () {
    corfu_fmt_cmd sequencer "$1"
}

corfu_fmt_layout_cmd () {
    corfu_fmt_cmd layout "$1"
}

corfu_fmt_log_cmd () {
    corfu_fmt_cmd log "$1"
}

corfu_fmt_cmd () {
    c_type="$1"
    i="$2"
    case $c_type in
	sequencer)
	    type_str="echo \$CORFU_SEQUENCER_TYPE_${i}"
	    host_str="echo \$CORFU_SEQUENCER_HOST_${i}"
	    port_str="echo \$CORFU_SEQUENCER_PORT_${i}"
	    debug_str="echo \$CORFU_SEQUENCER_DEBUG_${i}"
	    ;;
	layout)
	    type_str="echo \$CORFU_LAYOUT_TYPE_${i}"
	    host_str="echo \$CORFU_LAYOUT_HOST_${i}"
	    port_str="echo \$CORFU_LAYOUT_PORT_${i}"
	    debug_str="echo \$CORFU_LAYOUT_DEBUG_${i}"
	    ;;
	log)
	    type_str="echo \$CORFU_LOG_TYPE_${i}"
	    host_str="echo \$CORFU_LOG_HOST_${i}"
	    port_str="echo \$CORFU_LOG_PORT_${i}"
	    debug_str="echo \$CORFU_LOG_DEBUG_${i}"
	    ;;
	*)
	    echo "Unknown c_type: $c_type"
	    exit 1
    esac

    CORFU_CMD="$CORFU_SRC_DIR/bin/corfu_server -l %s -a %s -t -1 -d %s %s"
    if [ `eval $type_str` = memory ]; then
	echo TODO: memory type printf
    else
	log_dir="$CORFU_LOG_DIR/log/${c_type}.${i}"
	mkdir -p "$log_dir"
	printf "$CORFU_CMD" "$log_dir" `eval $host_str` \
	       `eval $debug_str` `eval $port_str`
    fi
}
