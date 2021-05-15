#!/bin/bash
mkdir -p /wsjtx-src/hamlib-prefix /hamlib/

cd /wsjtx-src/hamlib-prefix

## Build chain
apt-get install -y \
autoconf \
automake \
asciidoc \
cmake \
build-essential \
libtool \
gfortran \
git \
libqt5serialport5-dev \
libboost-log-dev \
libqt5quick5 \
libqt5multimedia5-plugins \
libusb-1.0-0-dev \
libudev-dev \
libfftw3-dev \
qttools5-dev \
qtmultimedia5-dev \
qtbase5-dev \
qtdeclarative5-dev \
texinfo \
&& apt-get clean 

### Build Hamlib for WSJTX
git clone git://git.code.sf.net/u/bsomervi/hamlib src
cd src
git checkout integration
./bootstrap
mkdir ../build
cd ../build
../src/configure --prefix=/hamlib \
   --disable-shared --enable-static \
   --without-cxx-binding --disable-winradio \
   CFLAGS="-g -O2 -fdata-sections -ffunction-sections" \
   LDFLAGS="-Wl,--gc-sections"
make
make install-strip

### Build WSJTX
mkdir -p /wsjtx-src/build
cd /wsjtx-src
git clone git://git.code.sf.net/p/wsjt/wsjtx src

cd /wsjtx-src/build
cmake -D CMAKE_PREFIX_PATH=/hamlib \
    -DWSJT_SKIP_MANPAGES=ON -DWSJT_GENERATE_DOCS=OFF \
    -D CMAKE_INSTALL_PREFIX=/wsjtx ../src
time cmake --build .
time cmake --build . --target install
