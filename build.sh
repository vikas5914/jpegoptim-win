#!/bin/bash

# exit the script if a command fails
set -o errexit
# exit the script if a command fails even in pipes
set -o pipefail
# exit the script if using an undefined variable
set -o nounset

if [ ! -d /usr/lib/mxe/usr/bin ]; then
   # Install MXE
   echo 'deb http://pkg.mxe.cc/repos/apt/debian wheezy main' | sudo tee --append /etc/apt/sources.list.d/mxeapt.list
   sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D43A795B73B16ABE9643FE1AFD8FFF16DB45C6AB
   sudo apt-get update
   sudo apt-get install -y mxe-i686-w64-mingw32.static-gcc mxe-x86-64-w64-mingw32.static-gcc mxe-i686-w64-mingw32.static-libjpeg-turbo mxe-x86-64-w64-mingw32.static-libjpeg-turbo
fi

# clear the environment variables

# add MXE binaries to the path
export PATH=/usr/lib/mxe/usr/bin:$PATH


current="$PWD"

# build jpegoptim for 32 bit Windows
cd "$current"
rm -rf jpegoptim
git clone --depth=1 https://github.com/tjko/jpegoptim.git
cd jpegoptim
export CPPFLAGS="-I /usr/lib/mxe/usr/i686-w64-mingw32.static/include/libjpeg-turbo"
./configure --host=i686-w64-mingw32.static --with-libjpeg=/usr/lib/mxe/usr/i686-w64-mingw32.static/lib/libjpeg-turbo
make
/usr/lib/mxe/usr/bin/i686-w64-mingw32.static-strip --strip-unneeded jpegoptim -o ../jpegoptim-32.exe

# build jpegoptim for 64 bit Windows
cd "$current"
rm -rf jpegoptim
git clone --depth=1 https://github.com/tjko/jpegoptim.git
cd jpegoptim
export CPPFLAGS="-I /usr/lib/mxe/usr/x86_64-w64-mingw32.static/include/libjpeg-turbo"
./configure --host=x86_64-w64-mingw32.static --with-libjpeg=/usr/lib/mxe/usr/x86_64-w64-mingw32.static/lib/libjpeg-turbo
make
/usr/lib/mxe/usr/bin/x86_64-w64-mingw32.static-strip --strip-unneeded jpegoptim -o ../jpegoptim-64.exe

# cleanup
cd "$current"
rm -rf jpegoptim
