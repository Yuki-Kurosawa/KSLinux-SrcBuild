
# build tmp system
cd $BUILDTMP

# install kernel headers
tar xvf $SRCROOT/$KERNEL_TAR
cd $KERNEL_SRC
make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include/* $CROSS/include
cd ..
rm -rf $KERNEL_SRC

# install glibc
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $CROSS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $CROSS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $CROSS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

tar xvf $SRCROOT/$GLIBC_TAR
cd $GLIBC_SRC
patch -Np1 -i $SRCROOT/glibc-fhs-1.patch
patch -Np1 -i $SRCROOT/glibc-2.44-upstream_fixes-1.patch

mkdir -v build
cd build
echo "rootsbindir=$CROSS/sbin" > configparms

../configure                             \
      --prefix=$CROSS                    \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --disable-nscd                     \
      --with-headers=$CROSS/include      \
      libc_cv_slibdir=$CROSS/lib         \
      --enable-kernel=5.10

$MAKE $MFLAGS
$MAKE $MFLAGS install

echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep "$CROSS"
ldd a.out
file a.out
rm -v dummy.c a.out
cd ../../
rm -rf $GLIBC_SRC


# build Libstdc++
cd $BUILDTMP
tar xvf $SRCROOT/$GCC_TAR
cd $GCC_SRC

case "$UNAMEM" in
    i386|i486|i586|i686|amd64|x86_64)
  tar -xf $SRCROOT/$MPFR_TAR
  mv -v $MPFR_SRC mpfr
  tar -xf $SRCROOT/$GMP_TAR
  mv -v $GMP_SRC gmp
  tar -xf $SRCROOT/$MPC_TAR
  mv -v $MPC_SRC mpc
  ;;
    armv7l|armhf|armv8l|aarch64)
  ./contrib/download_prerequisites
  			;;
	esac

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h -o -name aarch64-linux.h -o -name linux-eabi.h)
do
  cp -uv $file{,.orig}
  sed -e "s@/lib\(64\)\?\(32\)\?/ld@$CROSS&@g" \
      -e "s@/usr@$CROSS@g" $file.orig > $file
  echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"$CROSS/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
  touch $file.orig
done

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
  aarch64)
	sed -e '/mabi.lp64=/s/lib64/lib/' \
        -i.orig gcc/config/aarch64/t-aarch64-linux
  ;;
esac

mkdir -v build
cd build

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    CXX=$LFS_TGT-gcc                \
    --prefix=$CROSS                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=$CROSS/$LFS_TGT/include/c++/16.2.0

$MAKE $MFLAGS
$MAKE $MFLAGS install
rm -v $CROSS/lib/lib{stdc++{,exp,fs},supc++}.la

cd ../../
rm -rf $GCC_SRC

# build binutils-2
cd $BUILDTMP
tar xvf $SRCROOT/$BINUTILS_TAR
cd $BINUTILS_SRC
sed '6031s/$add_dir//' -i ltmain.sh

mkdir -v build
cd build

../configure                   \
    --prefix=$CROSS           \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu

$MAKE $MFLAGS
$MAKE $MFLAGS install
rm -v $CROSS/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

cd ../../
rm -rf $BINUTILS_SRC

# build gcc-2
cd $BUILDTMP
tar xvf $SRCROOT/$GCC_TAR
cd $GCC_SRC

case "$UNAMEM" in
    i386|i486|i586|i686|amd64|x86_64)
  tar -xf $SRCROOT/$MPFR_TAR
  mv -v $MPFR_SRC mpfr
  tar -xf $SRCROOT/$GMP_TAR
  mv -v $GMP_SRC gmp
  tar -xf $SRCROOT/$MPC_TAR
  mv -v $MPC_SRC mpc
  ;;
    armv7l|armhf|armv8l|aarch64)
  ./contrib/download_prerequisites
  ;;
esac

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
  aarch64)
    sed -e '/mabi.lp64=/s/lib64/lib/' \
        -i.orig gcc/config/aarch64/t-aarch64-linux
  ;;
esac


for file in \
  $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h -o -name aarch64-linux.h -o -name linux-eabi.h)
do
  cp -uv $file{,.orig}
  sed -e "s@/lib\(64\)\?\(32\)\?/ld@$CROSS&@g" \
      -e "s@/usr@$CROSS@g" $file.orig > $file
  echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"$CROSS/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
  touch $file.orig
done

mkdir -v build
cd build

CC=$LFS_TGT-gcc                                    \
CXX=$LFS_TGT-g++                                   \
AR=$LFS_TGT-ar                                     \
RANLIB=$LFS_TGT-ranlib                             \
../configure                                       \
    --prefix=$CROSS                                \
    --with-local-prefix=$CROSS                    \
    --with-native-system-header-dir=$CROSS/include \
    --disable-multilib                             \
    --disable-libgomp                              \
    --disable-libsanitizer                         \
    --disable-bootstrap                            \
    --disable-libstdcxx-pch                        \
    --enable-languages=c,c++ $GFLAGS

$MAKE $MFLAGS
$MAKE $MFLAGS install
ln -sv gcc $CROSS/bin/cc

echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep "$CROSS"
ldd a.out
file a.out
rm -v dummy.c a.out

cd ../../
rm -rf $GCC_SRC
