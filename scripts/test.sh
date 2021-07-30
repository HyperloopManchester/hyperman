#!/bin/sh

USAGE() {
	echo "Usage: $(basename $0) [log|main|motor|native|web]"
	echo "\tRuns tests for the given node, or native tests if no node is given"
}

TEST() {
	__ENVIRONMENT=$1
	__UPLOAD_PORT=$2
	if [ "${__UPLOAD_PORT:-z}" = "z" ]; then
		shift 1
		pio test -e $__ENVIRONMENT $@
	else
		shift 2
		pio remote test -e $__ENVIRONMENT --upload-port $__UPLOAD_PORT $@
	fi
}

BOARD=$1

[ "${BOARD:-z}" = "z" ] && TEST native && exit 0

case $BOARD in
	-h)
		USAGE && exit 1
		;;
	log)
		TEST log_node /dev/ttyACM0
		;;
	main)
		TEST main_node /dev/ttyACM1
		;;
	motor)
		TEST motor_node /dev/ttyACM2
		;;
	web)
		TEST web_node /dev/ttyACM3
		;;
	native)
		TEST native
		;;
	*)
		USAGE && exit 1
		;;
esac
