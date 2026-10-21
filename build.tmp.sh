
# install Tcl-core
cd $BUILDTMP
tar xvf $SRCROOT/$TCL_TAR
cd $TCL_SRC
ls
cd unix
./configure --prefix=$CROSS
$MAKE $MFLAGS
TZ=UTC $MAKE test
$MAKE install
chmod -v u+w $CROSS/lib/$TCL_LIB
$MAKE install-private-headers
ln -sv $TCL_BIN $CROSS/bin/tclsh
cd ../..
rm -rf $TCL_SRC

# install expect
cd $BUILDTMP
tar xvf $SRCROOT/$EXPECT_TAR
cd $EXPECT_SRC
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure
./configure --prefix=$CROSS       \
            --with-tcl=$CROSS/lib \
            --with-tclinclude=$CROSS/include
$MAKE $MFLAGS
$MAKE test
$MAKE SCRIPTS="" install
cd ..
rm -rf $EXPECT_SRC

# install DejaGNU
cd $BUILDTMP
tar xvf $SRCROOT/$DEJAGNU_TAR
cd $DEJAGNU_SRC
./configure --prefix=$CROSS
$MAKE install
$MAKE check
cd ..
rm -rf $DEJAGNU_SRC

# install Ncurse
cd $BUILDTMP
tar xvf $SRCROOT/$NCURSE_TAR
cd $NCURSE_SRC
mkdir build
pushd build
  ../configure --prefix=$CROSS AWK=gawk
  make -C include
  make -C progs tic
  install progs/tic $CROSS/bin
popd

./configure --prefix=$CROSS                \
            --host=$LFS_TGT               \
            --build=$(./config.guess)     \
            --mandir=$CROSS/share/man     \
            --with-manpage-format=normal  \
            --with-shared                 \
            --without-normal              \
            --with-cxx-shared             \
            --without-debug               \
            --without-ada                \
            --disable-stripping           \
            AWK=gawk
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $NCURSE_SRC

# install bash
cd $BUILDTMP
tar xvf $SRCROOT/$BASH_TAR
cd $BASH_SRC
./configure --prefix=$CROSS                \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                \
            --without-bash-malloc          \
            --docdir=$CROSS/share/doc/bash-5.3
$MAKE $MFLAGS
$MAKE install
ln -sv bash $CROSS/bin/sh
cd ..
rm -rf $BASH_SRC

# install bzip2
cd $BUILDTMP
tar xvf $SRCROOT/$BZIP2_TAR
cd $BZIP2_SRC
$MAKE $MFLAGS
$MAKE PREFIX=$CROSS install
cd ..
rm -rf $BZIP2_SRC

# install coreutils
cd $BUILDTMP
tar xvf $SRCROOT/$COREUTILS_TAR
cd $COREUTILS_SRC
./configure --prefix=$CROSS                \
            --host=$LFS_TGT                \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname
$MAKE $MFLAGS
$MAKE install
mv -v $CROSS/bin/chroot $CROSS/sbin
mkdir -pv $CROSS/share/man/man8
mv -v $CROSS/share/man/man1/chroot.1 $CROSS/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' $CROSS/share/man/man8/chroot.8
cd ..
rm -rf $COREUTILS_SRC

# install diffutils
cd $BUILDTMP
tar xvf $SRCROOT/$DIFFUTILS_TAR
cd $DIFFUTILS_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $DIFFUTILS_SRC

# install file
cd $BUILDTMP
tar xvf $SRCROOT/$FILE_TAR
cd $FILE_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $FILE_SRC

# install findutils
cd $BUILDTMP
tar xvf $SRCROOT/$FINDUTILS_TAR
cd $FINDUTILS_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $FINDUTILS_SRC

# install gawk
cd $BUILDTMP
tar xvf $SRCROOT/$GAWK_TAR
cd $GAWK_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $GAWK_SRC

# install gettext
cd $BUILDTMP
tar xvf $SRCROOT/$GETTEXT_TAR
cd $GETTEXT_SRC
cd gettext-tools
EMACS="no" ./configure --prefix=$CROSS --disable-shared
$MAKE -C gnulib-lib
$MAKE -C intl pluralx.c
$MAKE -C src msgfmt
$MAKE -C src msgmerge
$MAKE -C src xgettext
cp -v src/{msgfmt,msgmerge,xgettext} $CROSS/bin
cd ../..
rm -rf $GETTEXT_SRC

# install grep
cd $BUILDTMP
tar xvf $SRCROOT/$GREP_TAR
cd $GREP_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $GREP_SRC

# install gzip
cd $BUILDTMP
tar xvf $SRCROOT/$GZIP_TAR
cd $GZIP_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $GZIP_SRC

# install m4
cd $BUILDTMP
tar xvf $SRCROOT/$M4_TAR
cd $M4_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $M4_SRC

# install make
cd $BUILDTMP
tar xvf $SRCROOT/$MAKE_TAR
cd $MAKE_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess) --without-guile
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $MAKE_SRC

# install patch
cd $BUILDTMP
tar xvf $SRCROOT/$PATCH_TAR
cd $PATCH_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $PATCH_SRC

# install perl
cd $BUILDTMP
tar xvf $SRCROOT/$PERL_TAR
cd $PERL_SRC
sh Configure -des -Dprefix=$CROSS -Dlibs=-lm
$MAKE $MFLAGS
cp -v perl cpan/podlators/pod2man $CROSS/bin
mkdir -pv $CROSS/lib/perl5/5.44.0
cp -Rv lib/* $CROSS/lib/perl5/5.44.0
cd ..
rm -rf $PERL_SRC

# install sed
cd $BUILDTMP
tar xvf $SRCROOT/$SED_TAR
cd $SED_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $SED_SRC

# install tar
cd $BUILDTMP
tar xvf $SRCROOT/$TAR_TAR
cd $TAR_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $TAR_SRC

# install texinfo
cd $BUILDTMP
tar xvf $SRCROOT/$TEXINFO_TAR
cd $TEXINFO_SRC
./configure --prefix=$CROSS
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $TEXINFO_SRC

# install Util-linux
cd $BUILDTMP
tar xvf $SRCROOT/$UTIL_LINUX_TAR
cd $UTIL_LINUX_SRC
./configure --prefix=$CROSS                \
            --without-python               \
            --disable-makeinstall-chown    \
            --without-systemdsystemunitdir \
            PKG_CONFIG=""
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $UTIL_LINUX_SRC

# install xz
cd $BUILDTMP
tar xvf $SRCROOT/$XZ_TAR
cd $XZ_SRC
./configure --prefix=$CROSS --host=$LFS_TGT --build=$(./config.guess)
$MAKE $MFLAGS
$MAKE install
cd ..
rm -rf $XZ_SRC
