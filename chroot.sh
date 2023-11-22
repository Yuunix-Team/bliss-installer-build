#!/bin/sh

export PATH=/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin

mkdir -p android apex boot data gearroot gearload system vendor linkerconfig

echo 'localhost' > /etc/hostname

gpg --batch --passphrase '' --quick-gen-key 'root@localhost' default default

abuild-keygen --append
