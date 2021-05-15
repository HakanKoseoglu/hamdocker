#!/bin/bash
mkdir -p /jtdx-src/hamlib-src /hamlib/

cd /jtdx-src/hamlib-src

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
libqt5websockets5-dev \
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

## Build Hamlib for JTDX

mkdir /jtdx-src/hamlib-src
cd /jtdx-src/hamlib-src
git clone git://github.com/jtdx-project/jtdxhamlib src
cd src
./bootstrap
mkdir ../build
cd ../build
../src/configure --prefix=/hamlib \
   --disable-shared --enable-static --without-readline \
   --without-indi --without-cxx-binding --disable-winradio \
   CFLAGS="-g -O2 -fdata-sections -ffunction-sections" \
   LDFLAGS="-Wl,--gc-sections"
make
make install-strip

### Build JTDX
mkdir -p /jtdx-src/build
cd /jtdx-src
git clone git://github.com/jtdx-project/jtdx src

cd /jtdx-src/build
cmake -D CMAKE_PREFIX_PATH=/hamlib \
    -DWSJT_SKIP_MANPAGES=ON -DWSJT_GENERATE_DOCS=OFF \
    -D CMAKE_INSTALL_PREFIX=/jtdx ../src
time cmake --build .
time cmake --build . --target install
