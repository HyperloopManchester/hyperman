#!/bin/sh

. "$(dirname $0)/common.sh"

TARGET="$1"
PLATFORM="$2"
TARGET_MAIN="${TARGET}_main.c"
TARGET_LINKER_SCRIPT="$LIB/stdlib/$PLATFORM.ld"
TARGET_BSP="$LIB/stdlib/bsp_$PLATFORM.c"

UNITY="$(mktemp --suffix=.c)"
echo "" > "$UNITY"

echo "#include \"$(realpath $TARGET_BSP)\"" >> "$UNITY"
find $SRC -name '*.c' ! -name '*_main.c' -exec echo "#include \"$(realpath {})\"" >> "$UNITY" \;
echo "#include \"$(realpath $ROOT/$TARGET_MAIN)\"" >> "$UNITY"

EXEC $CC -o "$OUT/$TARGET.elf" "$UNITY" $CCXFLAGS $CPPFLAGS $LDDFLAGS "-T$TARGET_LINKER_SCRIPT"

rm "$UNITY"

EXEC $OBJCOPY -O ihex -R .eeprom -R .fuse -R .lock -R .signature $OUT/$TARGET.elf $OUT/$TARGET.hex
