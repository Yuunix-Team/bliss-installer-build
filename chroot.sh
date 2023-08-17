#!/bin/bash

export PATH=/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin

/bin/busybox --install -s

mkdir -p android apex boot data gearroot gearload system vendor

cd /lib
for so in *; do
    if [ -h "/usr/lib/$so" ] || [ ! -e "/usr/lib/$so" ]; then
        cp -rf /lib/"$so" /usr/lib/ || true
    fi
done

for d in bin sbin usr/sbin; do
    cd /$d
    for b in *; do
        if [ -h "/usr/bin/$b" ] || [ ! -e "/usr/bin/$b" ]; then
            cp -rf /$d/"$b" /usr/bin/ || true
        fi
    done
done
