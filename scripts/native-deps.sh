#!/bin/sh

. "$(dirname $0)/build-common.sh"

__OLD="$(pwd)"
cd $LIB/stdlib/src
	SOURCES="$(find -name '*.c')"
cd $__OLD

for stdlib_src in $SOURCES; do
	EXEC mkdir -p $(dirname $OUT/stdlib-native/$stdlib_src.o)
	EXEC $NATIVE_CC -o $OUT/stdlib-native/$stdlib_src.o -c $LIB/stdlib/src/$stdlib_src $STDLIB_CCXFLAGS $STDLIB_CPPFLAGS $STDLIB_LDDFLAGS
done

OBJECTS="$(find $OUT/stdlib-native -name '*.o')"

EXEC $NATIVE_AR rcs $OUT/libstdlib-native.a $OBJECTS
