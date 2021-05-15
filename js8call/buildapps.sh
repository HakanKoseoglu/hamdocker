#!/bin/bash
mkdir -p /js8call-src/hamlib-prefix /hamlib/

cd /js8call-src/hamlib-prefix

apt-get install -y build-essential autoconf automake libtool cmake git qttools5-dev qtmultimedia5-dev libqt5serialport5-dev qtbase5-dev libboost-log-dev libqt5quick5 gfortran libusb-1.0-0-dev libudev-dev libfftw3-dev libpulse0  && apt-get clean 

### Build Hamlib for JS8Call
git clone https://github.com/Hamlib/Hamlib.git src
cd src
git checkout integration
./bootstrap
mkdir -p ../build
cd ../build
../src/configure --prefix=/hamlib \
   --disable-shared --enable-static \
   --without-cxx-binding --disable-winradio \
   CFLAGS="-g -O2 -fdata-sections -ffunction-sections" \
   LDFLAGS="-Wl,--gc-sections"
make
make install-strip

### Build JS8Call
mkdir -p /js8call-src
cd /js8call-src
git clone https://bitbucket.org/widefido/js8call.git src

cd /js8call-src/src
mkdir -p ../build
cd ../build
cmake -D CMAKE_PREFIX_PATH=/hamlib -D CMAKE_INSTALL_PREFIX=/js8call ../src
make install
