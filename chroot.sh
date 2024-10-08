#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

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
	vendor; do ln -s android/$d /; done

rm -rf /lib/modules /lib/firmware /usr/lib/modules /usr/lib/firmware
ln -s /system/lib/modules /vendor/firmare /lib
ln -s /system/lib/modules /vendor/firmare /usr/lib

echo 'blissos.org' >/etc/hostname

rc-update add acpid default
rc-update add bootmisc boot
rc-update add devfs sysinit
rc-update add dmesg sysinit
rc-update add hostname boot
rc-update add hwdrivers sysinit
rc-update add killprocs shutdown
rc-update add modules boot
rc-update add udev-postmount default
rc-update add udev-settle sysinit
rc-update add udev-trigger sysinit
rc-update add udev sysinit

cat <<EOF >/usr/sbin/autologin
#!/bin/sh
exec login -f root
EOF
chmod +x /usr/sbin/autologin
sed -i 's@1::respawn:/sbin/getty@1::respawn:/sbin/getty -n -l /usr/sbin/autologin@g' /etc/inittab
sed -i -r 's|^(root:.*:)/bin/a?sh$|\1/bin/bash|g' /etc/passwd
mkdir -p /root	

# shellcheck disable=SC2016
echo '[ -z "$DISPLAY" ] && { startx /usr/bin/calamares; poweroff; }' >/root/.bash_profile
chmod +x /root/.bash_profile
