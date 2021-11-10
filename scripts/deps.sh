#!/bin/sh

. "$(dirname $0)/common.sh"

PLATFORM="$1"
TARGET_BSP="$LIB/stdlib/bsp_$PLATFORM.c"

UNITY="$(mktemp --suffix=.c)"
echo "" > "$UNITY"

echo "#include \"$(realpath $TARGET_BSP)\"" >> "$UNITY"
find "$LIB/stdlib/src" -name '*.c' -exec echo "#include \"$(realpath {})\"" >> "$UNITY" \;

EXEC $CC -o "$OUT/stdlib.o" -c "$UNITY" $STDLIB_CXXFLAGS $STDLIB_CPPFLAGS $STDLIB_LDDFLAGS

rm "$UNITY"

EXEC $AR rcs "$OUT/libstdlib.a" "$OUT/stdlib.o"
