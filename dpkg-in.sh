# install dpkg
cd $BUILDTMP
tar xvf $SCRIPTROOT/$DPKG_TAR
cd $DPKG_SRC
./configure --prefix=$CROSS
make
make install
cd ..
rm -rf $DPKG_SRC
mkdir -p $KS$CROSS/var/lib/dpkg
