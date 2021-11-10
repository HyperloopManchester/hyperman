#!/bin/sh

. "$(dirname $0)/common.sh"

UNITY="$(mktemp --suffix=.c)"
echo "" > "$UNITY"

find "$MOCK" -name '*.c' -exec echo "#include \"$(realpath {})\"" >> "$UNITY" \;

EXEC $NATIVE_CC -o "$OUT/mock.o" -c "$UNITY" $MOCKLIB_CXXFLAGS $MOCKLIB_CPPFLAGS $MOCKLIB_LDDFLAGS

rm "$UNITY"

EXEC $NATIVE_AR rcs "$OUT/libmock.a" "$OUT/mock.o"
