#!/bin/sh

. "$(dirname $0)/common.sh"

# to avoid rebuilding unnecessarily, we have a timestamp
TIMESTAMP="$TOOLS/build-timestamp"

if [ -f "$TIMESTAMP" ]; then
	echo "NOTE: $TIMESTAMP present; not rebuilding cross-toolchain!"
	echo "NOTE: to rebuild cross-toolchain, delete the timestamp file and run $0 again"
	exit 0

fi

# tools sources
BIN_VER="2.37"
BIN_PKG="binutils-$BIN_VER"
BIN_ARCHIVE="$BIN_PKG.tar.xz"
BIN_SRC="http://ftp.gnu.org/gnu/binutils/$BIN_ARCHIVE"

GCC_VER="11.2.0"
GCC_PKG="gcc-$GCC_VER"
GCC_ARCHIVE="$GCC_PKG.tar.xz"
GCC_SRC="http://gcc.gnu.org/pub/gcc/releases/gcc-$GCC_VER/$GCC_ARCHIVE"

GMP_VER="6.2.1"
GMP_PKG="gmp-$GMP_VER"
GMP_ARCHIVE="$GMP_PKG.tar.xz"
GMP_SRC="http://ftp.gnu.org/gnu/gmp/$GMP_ARCHIVE"

MPC_VER="1.2.1"
MPC_PKG="mpc-$MPC_VER"
MPC_ARCHIVE="$MPC_PKG.tar.gz"
MPC_SRC="http://ftp.gnu.org/gnu/mpc/$MPC_ARCHIVE"

MPFR_VER="4.1.0"
MPFR_PKG="mpfr-$MPFR_VER"
MPFR_ARCHIVE="$MPFR_PKG.tar.xz"
MPFR_SRC="http://ftp.gnu.org/gnu/mpfr/$MPFR_ARCHIVE"

TEENSY_LOADER_PKG="teensy_loader_cli"
TEENSY_LOADER_SRC="https://github.com/PaulStoffregen/$TEENSY_LOADER_PKG"

# download tools
DOWNLOAD() {
	__OLD="$(pwd)"

	echo "Downloading : $1"

	# download source
	[ ! -e "$1" ] && curl "$2" -o "$1"

	# download source sha512 hash
	SUM_SRC="$(dirname $2)/sha512.sum"
	if [ "$(curl -o /dev/null -sI -w '%{http_code}' $SUM_SRC)" = "200" ]; then
		curl -s "$SUM_SRC" -o "$1.sha512sum"

		# we need to change dirs to make sure sha512sum gets the correct filename
		cd "$(dirname $1)"

		sha512sum -c "$(basename $1).sha512sum" --ignore-missing
	fi
	cd $__OLD
}

DOWNLOAD $TOOLS/$BIN_ARCHIVE $BIN_SRC
DOWNLOAD $TOOLS/$GCC_ARCHIVE $GCC_SRC
DOWNLOAD $TOOLS/$GMP_ARCHIVE $GMP_SRC
DOWNLOAD $TOOLS/$MPC_ARCHIVE $MPC_SRC
DOWNLOAD $TOOLS/$MPFR_ARCHIVE $MPFR_SRC

[ ! -d "$TOOLS/teensy_loader_cli" ] && git clone $TEENSY_LOADER_SRC $TOOLS/teensy_loader_cli

# build tools
EXTRACT() {
	tar xf "$1" -C $TOOLS
}

echo "Building cross-binutils..."
EXTRACT $TOOLS/$BIN_ARCHIVE $TOOLS/$BIN_PKG

__OLD="$(pwd)"
cd $TOOLS/$BIN_PKG

mkdir binutils-build
cd binutils-build

../configure \
	--prefix="$CROSS_ROOT" \
	--target="$GCC_TARGET" \
	--with-sysroot \
	--disable-nls \
	--disable-shared

make && make install
[ $? -ne 0 ] && exit 1

cd $__OLD

echo "Building cross-gcc..."
EXTRACT $TOOLS/$GCC_ARCHIVE $TOOLS/$GCC_PKG
EXTRACT $TOOLS/$GMP_ARCHIVE $TOOLS/$GMP_PKG
EXTRACT $TOOLS/$MPC_ARCHIVE $TOOLS/$MPC_PKG
EXTRACT $TOOLS/$MPFR_ARCHIVE $TOOLS/$MPFR_PKG

mv $TOOLS/$GMP_PKG $TOOLS/$GCC_PKG/gmp
mv $TOOLS/$MPC_PKG $TOOLS/$GCC_PKG/mpc
mv $TOOLS/$MPFR_PKG $TOOLS/$GCC_PKG/mpfr

__OLD="$(pwd)"
cd $TOOLS/$GCC_PKG

mkdir gcc-build
cd gcc-build

../configure \
	--prefix="$CROSS_ROOT" \
	--target="$GCC_TARGET" \
	--enable-languages=c \
	--without-headers \
	--disable-nls \
	--disable-shared

make all-gcc all-target-libgcc && make install-gcc install-target-libgcc
[ $? -ne 0 ] && exit 1

cd $__OLD

echo "Building teensy_loader_cli..."
make -C $TOOLS/$TEENSY_LOADER_PKG
cp $TOOLS/$TEENSY_LOADER_PKG/teensy_loader_cli $TOOLSBIN
[ $? -ne 0 ] && exit 1

touch $TIMESTAMP
