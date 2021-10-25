#!/bin/sh

ROOT="$(dirname $0)/.."

# to speed up build
export MAKEFLAGS="-j$(nproc)"
COMMON_FLAGS="-O2 -pipe"
export CFLAGS="$COMMON_FLAGS"
export CXXFLAGS="$COMMON_FLAGS"
export LDFLAGS=""

GCC_TARGET="arm-none-eabi"
GCC_ARCH=""
GCC_OPTS=""

TOOLS="$ROOT/tools"
CROSS_ROOT="$(realpath $TOOLS/cross)"
TOOLSBIN="$CROSS_ROOT/bin"
mkdir -p "$TOOLS" "$CROSS_ROOT" "$TOOLSBIN"

# execute a command, printing it to stdout if VERBOSE=1
EXEC() { [ $VERBOSE ] && echo "$@"; $@; }
