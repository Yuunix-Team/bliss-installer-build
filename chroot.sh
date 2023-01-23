#!/bin/bash

export PATH=/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin

/bin/busybox --install -s

mkdir -p android apex boot data gearroot gearload system vendor

cd /lib
for so in *; do
    if [ -h "/usr/lib/$so" ] || [ ! -e "/usr/lib/$so" ]; then
        mv -f "/lib/$so" /usr/lib/
    fi
done
cd /
rm -rf /lib
ln -s /usr/lib /lib

cd /bin
for b in *; do
    if [ -h "/usr/bin/$b" ] || [ ! -e "/usr/bin/$b" ]; then
        mv -f "/bin/$b" /usr/bin/
    fi
done
cd /
rm -rf /bin
ln -s /usr/bin /bin

cd /sbin
for sb in *; do
    if [ -h "/usr/bin/$sb" ] || [ ! -e "/usr/bin/$sb" ]; then
        mv -f "/sbin/$sb" /usr/bin/
    fi
done
cd /
rm -rf /sbin
ln -s /usr/bin /sbin

cd /usr/sbin
for sb in *; do
    if [ -h "/usr/bin/$sb" ] || [ ! -e "/usr/bin/$sb" ]; then
        mv -f "/usr/sbin/$sb" /usr/bin/
    fi
done
cd /
rm -rf /usr/sbin
ln -s bin /usr/sbin
