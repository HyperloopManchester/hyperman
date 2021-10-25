#!/bin/sh

. "$(dirname $0)/build-common.sh"

TARGET="$1"

# tests must be collected when in the tests dir, to make sure that the ROOT
# isnt appended twice (which leads to include path errors and other fun
# issues)
__OLD="$(pwd)"
cd $TEST
	TESTS="$(find -L $TARGET -name 'test_*.c')"
cd $__OLD

FAILED=0
for test_src in $TESTS; do
	EXEC mkdir -p $(dirname $OUT/$test_src)
	EXEC $NATIVE_CC -o $OUT/$test_src.x $TEST/$test_src $TEST_CCXFLAGS $TEST_CPPFLAGS $TEST_LDDFLAGS && \
	LD_LIBRARY_PATH=$LIB:$OUT:$LD_LIBRARY_PATH  $OUT/$test_src.x

	[ $? -ne 0 ] && FAILED=1
done

[ $FAILED -eq 0 ]
