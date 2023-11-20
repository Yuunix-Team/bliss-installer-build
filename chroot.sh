#!/bin/sh

export PATH=/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin

mkdir -p android apex boot data gearroot gearload system vendor linkerconfig

# cd /lib
# for so in *; do
# 	if [ -h "/usr/lib/$so" ] || [ ! -e "/usr/lib/$so" ]; then
# 		cp -rf /lib/"$so" /usr/lib/ || true
# 	fi
# done

# for d in bin sbin usr/sbin; do
# 	cd /$d
# 	for b in *; do
# 		if [ -h "/usr/bin/$b" ] || [ ! -e "/usr/bin/$b" ]; then
# 			busybox mv -f /$d/"$b" /usr/bin/ || true
# 		fi
# 	done
# done

# shellcheck disable=SC2016
# busybox sed -i 's|GRUB_DEVICE="`${grub_probe} --target=device /`"|GRUB_DEVICE="`${grub_probe} --target=device "$ROOT"`"|g' /usr/bin/grub-mkconfig
