#!/bin/bash

export PATH=/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin

/bin/busybox --install -s

mkdir -p android apex boot data gearroot gearload system vendor

cd /lib
for so in *; do
    if [ -h "/usr/lib/$so" ] || [ ! -e "/usr/lib/$so" ]; then
        cp -rf /lib/"$so" /usr/lib/
    fi
done

cd /bin
for b in *; do
    if [ -h "/usr/bin/$b" ] || [ ! -e "/usr/bin/$b" ]; then
        cp -rf /bin/"$b" /usr/bin/
    fi
done

cd /sbin
for sb in *; do
    if [ -h "/usr/bin/$sb" ] || [ ! -e "/usr/bin/$sb" ]; then
        cp -rf /sbin/"$sb" /usr/bin/
    fi
done

cd /usr/sbin
for sb in *; do
    if [ -h "/usr/bin/$sb" ] || [ ! -e "/usr/bin/$sb" ]; then
        cp -rf /usr/sbin/"$sb" /usr/bin/
    fi
done
