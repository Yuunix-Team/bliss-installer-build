#!/bin/bash

export PATH=/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin

cd /
mkdir -p \
	android \
	boot/grub \
	boot/efi \
	cdrom
	
for d in data \
	data_mirror \
	system \
	storage \
	sdcard \
	apex \
	linkerconfig \
	debug_ramdisk \
	system_ext \
	product \
	vendor; do ln -s /android/$d /$d; done

for d in modules firmware; do ln -s /system/lib/$d /lib/$d; done

echo 'blissos.org' > /etc/hostname

rc-update add acpid default
rc-update add bootmisc boot
rc-update add devfs sysinit
rc-update add dmesg sysinit
rc-update add hostname boot
rc-update add hwdrivers sysinit
rc-update add killprocs shutdown
rc-update add mdev sysinit
rc-update add modules boot

sed -i -r 's/^\#?rc_logger="[A-Z]+"$/rc_logger="YES"/g' /etc/rc.conf

setup-user -a -g root,video,audio,mem,kmem,input,users,disk -u bliss
sed -i -r 's|^tty1.*|tty1::respawn:/sbin/agetty --autologin bliss tty1 linux|g' /etc/inittab
sed -i -r 's|^(bliss:.*:)/bin/sh$|\1/bin/bash|g' /etc/passwd

echo 'doas chown -hR bliss:bliss /home/bliss; [ -z "$DISPLAY" ] && startx /usr/bin/jwm; sh' > /home/bliss/.bash_profile
chown bliss:bliss /home/bliss/.bash_profile
chmod +x /home/bliss/.bash_profile

echo 'permit nopass :wheel' > /etc/doas.conf
echo 'permit nopass :wheel' > /etc/doas.d/doas.conf
