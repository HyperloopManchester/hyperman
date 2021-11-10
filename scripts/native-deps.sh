#!/bin/sh

. "$(dirname $0)/common.sh"

UNITY="$(mktemp --suffix=.c)"
echo "" > "$UNITY"

find "$LIB/stdlib/src" -name '*.c' -exec echo "#include \"$(realpath {})\"" >> "$UNITY" \;

EXEC $NATIVE_CC -o "$OUT/stdlib-native.o" -c "$UNITY" $NATIVE_STDLIB_CCXFLAGS $NATIVE_STDLIB_CPPFLAGS $NATIVE_STDLIB_LDDFLAGS

rm "$UNITY"

EXEC $NATIVE_AR rcs "$OUT/libstdlib-native.a" "$OUT/stdlib-native.o"
