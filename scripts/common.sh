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
OUT="$ROOT/out"
MOCK="$ROOT/mock"
TEST="$ROOT/test"

COMMON_CXXFLAGS="-std=c11 -Wall -Wextra -Wpedantic"
COMMON_CPPFLAGS="-I$INC -I$LIB/stdlib/include"
COMMON_LDDFLAGS="-L$OUT"

HYPERMAN_CXXFLAGS="$COMMON_CXXFLAGS -ffreestanding -Os -mthumb"
HYPERMAN_CPPFLAGS="$COMMON_CPPFLAGS"
HYPERMAN_LDDFLAGS="$COMMON_LDDFLAGS -nostdlib -lstdlib"

STDLIB_CXXFLAGS="$COMMON_CXXFLAGS -ffreestanding -Os -mthumb"
STDLIB_CPPFLAGS="$COMMON_CPPFLAGS"
STDLIB_LDDFLAGS="$COMMON_LDDFLAGS -nostdlib"

NATIVE_STDLIB_CXXFLAGS="$COMMON_CXXFLAGS"
NATIVE_STDLIB_CPPFLAGS="$COMMON_CPPFLAGS"
NATIVE_STDLIB_LDDFLAGS="$COMMON_LDDFLAGS"

TEST_CXXFLAGS="$COMMON_CXXFLAGS -Wno-unused-value"
TEST_CPPFLAGS="$COMMON_CPPFLAGS -I$MOCK -I$TEST"
TEST_LDDFLAGS="$COMMON_LDDFLAGS -lstdlib-native -lmock"

MOCKLIB_CXXFLAGS="$COMMON_CXXFLAGS -Wno-unused-value"
MOCKLIB_CPPFLAGS="$COMMON_CPPFLAGS -I$MOCK"
MOCKLIB_LDDFLAGS="$COMMON_LDDFLAGS -lstdlib-native"
