#!/bin/sh

. "$(dirname $0)/build-common.sh"

TARGET="$1"
TARGET_MAIN="${TARGET}_main.c"

__OLD="$(pwd)"
cd $SRC
	SOURCES="$(find -name '*.c' ! -name '*_main.c')"
cd $__OLD

for target_src in $SOURCES; do
	EXEC mkdir -p $(dirname $OUT/$TARGET/$target_src.o)
	EXEC $CC -o $OUT/$TARGET/$target_src.o -c $SRC/$target_src $CCXFLAGS $CPPFLAGS
done

EXEC mkdir -p $(dirname $OUT/$TARGET/$TARGET_MAIN.o)
EXEC $CC -o $OUT/$TARGET/$TARGET_MAIN.o -c $SRC/$TARGET_MAIN $CCXFLAGS $CPPFLAGS

OBJECTS="$(find $OUT/$TARGET -name '*.o')"

EXEC $CC -o $OUT/$TARGET.elf $OBJECTS $LDDFLAGS

EXEC $OBJCOPY -O ihex -R .eeprom -R .fuse -R .lock -R .signature $OUT/$TARGET.elf $OUT/$TARGET.hex
