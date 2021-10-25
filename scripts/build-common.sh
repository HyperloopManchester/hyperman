#!/bin/sh

. "$(dirname $0)/common.sh"

# embedded toolchain variables
AR="$GCC_TARGET-ar"
AS="$GCC_TARGET-as"
CC="$GCC_TARGET-gcc"
CPP="$GCC_TARGET-cpp"
LD="$GCC_TARGET-ld"
NM="$GCC_TARGET-nm"
OBJCOPY="$GCC_TARGET-objcopy"
OBJDUMP="$GCC_TARGET-objdump"
RANLIB="$GCC_TARGET-ranlib"
STRIP="$GCC_TARGET-strip"

LOADER="teensy_loader_cli"

# native toolchain variables (for tests)
NATIVE_AR="ar"
NATIVE_CC="gcc"
NATIVE_CPP="cpp"
NATIVE_LD="ld"

# update path to prefer cross-tools
export PATH="$TOOLSBIN:$PATH"

# hyperman variables
SRC="$ROOT/src"
INC="$ROOT/include"
LIB="$ROOT/lib"
TEST="$ROOT/test"
OUT="$ROOT/out"

LINKER_SCRIPT="imxrt1062_t41.ld"

CCXFLAGS="-std=c11 -ffreestanding -Os -Wall -Wextra -Wpedantic"
CPPFLAGS="-I$INC -I$LIB/stdlib/include"
LDDFLAGS="-T$LINKER_SCRIPT -ffreestanding -Os -nostdlib -lgcc -L$OUT -lstdlib"

TEST_CCXFLAGS="-std=c11 -Wall -Wextra -Wpedantic -Wno-unused-value"
TEST_CPPFLAGS="-I$INC -I$LIB/stdlib/include"
TEST_LDDFLAGS="-L$OUT -lstdlib-native"

STDLIB_CCXFLAGS="-std=c11 -ffreestanding -Os -Wall -Wextra -Wpedantic"
STDLIB_CPPFLAGS="-I$LIB/stdlib/include"
STDLIB_LDDFLAGS="-ffreestanding -Os -nostdlib -lgcc -L$OUT"

MOCKLIB_CCXFLAGS=""
MOCKLIB_CPPFLAGS=""
MOCKLIB_LDDFLAGS=""
