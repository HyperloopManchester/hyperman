#!/bin/sh

ROOT="$(dirname $0)/.."

GCC_TARGET="arm-none-eabi"

TOOLS="$(realpath $ROOT/tools)"
CROSS_ROOT="$TOOLS/cross"
CROSS_BIN="$CROSS_ROOT/bin"
mkdir -p "$TOOLS" "$CROSS_ROOT" "$CROSS_BIN"

# execute a command, printing it to stdout if VERBOSE=1
EXEC() { [ $VERBOSE ] && echo "$@"; $@; }

# native toolchain variables (for tests)
NATIVE_AR="${AR:-ar}"
NATIVE_AS="${AS:-as}"
NATIVE_CC="${CC:-gcc}"
NATIVE_LD="${LD:-ld}"
NATIVE_OBJCOPY="${OBJCOPY:-objcopy}"

# embedded toolchain variables
AR="$GCC_TARGET-ar"
AS="$GCC_TARGET-as"
CC="$GCC_TARGET-gcc"
LD="$GCC_TARGET-ld"
OBJCOPY="$GCC_TARGET-objcopy"

LOADER="teensy_loader_cli"

# update path to allow access to cross-toolchain
export PATH="$PATH:$CROSS_BIN"

# hyperman variables
SRC="$ROOT/src"
INC="$ROOT/include"
LIB="$ROOT/lib"
TEST="$ROOT/test"
OUT="$ROOT/out"

CCXFLAGS="-std=c11 -ffreestanding -Os -Wall -Wextra -Wpedantic -flto -mthumb"
CPPFLAGS="-I$INC -I$LIB/stdlib/include"
LDDFLAGS="-ffreestanding -Os -nostdlib -lgcc -L$OUT -lstdlib -flto"

TEST_CCXFLAGS="-std=c11 -Wall -Wextra -Wpedantic -Wno-unused-value"
TEST_CPPFLAGS="-I$INC -I$LIB/stdlib/include"
TEST_LDDFLAGS="-L$OUT -lstdlib-native"

STDLIB_CCXFLAGS="-std=c11 -ffreestanding -Os -Wall -Wextra -Wpedantic"
STDLIB_CPPFLAGS="-I$LIB/stdlib/include"
STDLIB_LDDFLAGS="-ffreestanding -Os -nostdlib -lgcc -L$OUT"

MOCKLIB_CCXFLAGS=""
MOCKLIB_CPPFLAGS=""
MOCKLIB_LDDFLAGS=""
