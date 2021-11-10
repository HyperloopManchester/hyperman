#!/bin/sh

. "$(dirname $0)/common.sh"

TARGET="$1"

# this requires going into the $TEST subdir first to ensure that we dont get
# the ./scripts/../test path fragment, but instead that we get a $TARGET/test.c
# path fragment (which is easier to place into the $OUT subdir)
OLD="$(pwd)"
cd "$TEST"
	TESTS="$(find -L "$TARGET" -name 'test_*.c')"
cd "$OLD"

FAILED=0
for test_src in $TESTS; do
	__TEST_NAME="$OUT/$test_src"
	EXEC mkdir -p "$(dirname $__TEST_NAME)"
	EXEC $NATIVE_CC -o "$__TEST_NAME.x" "$TEST/$test_src" $TEST_CCXFLAGS $TEST_CPPFLAGS $TEST_LDDFLAGS && \
	LD_LIBRARY_PATH="$LIB:$OUT:$LD_LIBRARY_PATH" "$OUT/$test_src.x"

	[ $? -ne 0 ] && FAILED=1
done

[ $FAILED -eq 0 ]
