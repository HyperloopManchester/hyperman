#!/bin/sh

USAGE() {
	echo "Usage: $(basename $0) <log|main|motor|web>"
	echo "\tBuilds and uploads to the given node"
}

UPLOAD() {
	__ENVIRONMENT=$1
	__UPLOAD_PORT=$2
	shift 2
	pio remote run -e $__ENVIRONMENT -t upload --upload-port $__UPLOAD_PORT $@
}

BOARD=$1

[ "${BOARD:-z}" = "z" ] && USAGE && exit 1

case $BOARD in
	-h)
		USAGE && exit 1
		;;
	log)
		UPLOAD log_node /dev/ttyACM0
		;;
	main)
		UPLOAD main_node /dev/ttyACM1
		;;
	motor)
		UPLOAD motor_node /dev/ttyACM2
		;;
	web)
		UPLOAD web_node /dev/ttyACM3
		;;
	*)
		USAGE && exit 1
		;;
esac
