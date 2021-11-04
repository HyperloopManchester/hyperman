#!/bin/sh

. "$(dirname $0)/common.sh"

TARGET="$1"

EXEC $LOADER -v --mcu=TEENSY41 -w $OUT/$TARGET.hex
