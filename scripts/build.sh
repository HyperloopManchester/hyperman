#!/bin/sh

. "$(dirname $0)/common.sh"

TARGET="$1"
TARGET_MAIN="${TARGET}.c"

PLATFORM="$2"
TARGET_LINKER_SCRIPT="$LIB/stdlib/${PLATFORM}.ld"

UNITY="$(mktemp --suffix=.c)"
echo "" > "$UNITY"

find "$SRC" -name '*.c' -exec echo "#include \"$(realpath {})\"" >> "$UNITY" \;
echo "#include \"$(realpath $ROOT/$TARGET_MAIN)\"" >> "$UNITY"

EXEC $CC -o "$OUT/$TARGET.elf" "$UNITY" $HYPERMAN_CXXFLAGS $HYPERMAN_CPPFLAGS $HYPERMAN_LDDFLAGS "-T$TARGET_LINKER_SCRIPT"

rm "$UNITY"

EXEC $OBJCOPY -O ihex -R .eeprom -R .fuse -R .lock -R .signature "$OUT/$TARGET.elf" "$OUT/$TARGET.hex"
