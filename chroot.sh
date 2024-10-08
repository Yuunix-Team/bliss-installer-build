#!/bin/bash

# shellcheck disable=SC1091
. /etc/profile

echo 'blissos.org' >/etc/hostname

setup-user -a -g users,abuild -u bliss
sed -i -r 's|^(bliss:.*:)/bin/sh$|\1/bin/bash|g' /etc/passwd

echo 'permit nopass :wheel' >/etc/doas.conf
echo 'permit nopass :wheel' >/etc/doas.d/doas.conf

su bliss -c /userchroot.sh

echo 'nameserver 1.1.1.1' >/etc/resolv.conf
