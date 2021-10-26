#!/bin/sh

. "$(dirname $0)/build-common.sh"

TARGET="$1"
TARGET_MAIN="${TARGET}_main.c"

UNITY="$(mktemp --suffix=.c)"
echo "" > "$UNITY"

SOURCES="$(find $SRC -name '*.c' ! -name '*_main.c' -exec echo "#include \"$(realpath {})\"" >> "$UNITY" \;)"
echo "#include \"$(realpath $SRC/$TARGET_MAIN)\"" >> "$UNITY"

EXEC $CC -o "$OUT/$TARGET.elf" "$UNITY" $CCXFLAGS $CPPFLAGS $LDDFLAGS

rm "$UNITY"

EXEC $OBJCOPY -O ihex -R .eeprom -R .fuse -R .lock -R .signature $OUT/$TARGET.elf $OUT/$TARGET.hex
