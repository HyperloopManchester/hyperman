#!/bin/sh

. "$(dirname $0)/build-common.sh"

__OLD="$(pwd)"
cd $LIB/stdlib/src
	SOURCES="$(find -name '*.c')"
cd $__OLD

for stdlib_src in $SOURCES; do
	EXEC mkdir -p $(dirname $OUT/stdlib/$stdlib_src.o)
	EXEC $CC -o $OUT/stdlib/$stdlib_src.o -c $LIB/stdlib/src/$stdlib_src $STDLIB_CCXFLAGS $STDLIB_CPPFLAGS $STDLIB_LDDFLAGS
done

OBJECTS="$(find $OUT/stdlib -name '*.o')"

EXEC $AR rcs $OUT/libstdlib.a $OBJECTS
