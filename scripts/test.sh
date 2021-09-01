#!/bin/sh

USAGE() {
	echo "Usage: $(basename $0) [all|log|main|motor|stdlib|web]"
	echo "\tRuns the given set of tests, or all tests if no set is given"
}

TEST() {
	__ENVIRONMENT=$1
	__UPLOAD_PORT=$2

	if [ "${__UPLOAD_PORT:-z}" = "z" ]; then
		shift 1
		[ $VERBOSE ] && echo "pio test -e $__ENVIRONMENT $@"
		pio test -e $__ENVIRONMENT $@
	else
		shift 2
		[ $VERBOSE ] && echo "pio remote test -e $__ENVIRONMENT --upload-port $__UPLOAD_PORT $@"
		pio remote test -e $__ENVIRONMENT --upload-port $__UPLOAD_PORT $@
	fi
}

BOARD=$1

[ "${BOARD:-z}" = "z" ] && BOARD=all

case $BOARD in
	-h)
		USAGE && exit 1
		;;
	all)
		TEST native
		;;
	log)
		TEST log_node /dev/ttyACM0 "-f log_node"
		;;
	main)
		TEST main_node /dev/ttyACM1 "-f main_node"
		;;
	motor)
		TEST motor_node /dev/ttyACM2 "-f motor_node"
		;;
	stdlib)
		TEST native "" "-f stdlib"
		;;
	web)
		TEST web_node /dev/ttyACM3 "-f web_node"
		;;
	*)
		USAGE && exit 1
		;;
esac
