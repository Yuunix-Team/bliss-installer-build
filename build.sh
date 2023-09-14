#!/bin/bash

. .rc

ckroot

while [[ "$1" ]]; do
	case "$1" in
	-c | --compression) [ -z "$2" ] && argerr "$1" || comp="$2" ;;
	-d | --builddir) [ -z "$2" ] && argerr "$1" || builddir="$2" ;;
	-o | --dist) [ -z "$2" ] && argerr "$1" || dist="$2" ;;
	-s | --squashfs) echo use=squashfs && shift && continue ;;
	-i | --img) use=img && shift && continue ;;
	-b | --cpio) use=cpio && shift && continue ;;
	*) break ;;
	esac
	shift 2
done
PWD=$(pwd)

if [ "$use" != "img" ]; then
	[ -z "$comp" ] && read -rp "Enter compression program: (default: gzip): " comp
	[ -z "$comp" ] && comp=gzip
fi

[ "$builddir" ] || builddir=./build
echo "Build directory is $builddir"

[ "$dist" ] || dist=./dist/gearlock.img
echo "Generate to $dist"
[ -z "$use" ] && use=img

rm -rf build dist
mkdir -p build dist

# cd tmp
apk --arch "$arch" \
	-X "$(cat apk/repositories)" \
	-X "$mirror/$branch/main/" \
	-X "$mirror/$branch/community/" \
	--no-cache \
	-U --allow-untrusted --progress \
	fetch $(tr "\n" " " <"$pkglist") || cmderr
# cd ..

if [ "$use" = "img" ]; then
	if [ "$(command -v truncate)" ]; then
		truncate -s 4096M "$dist"
		ls $dist
	else
		dd if=/dev/zero of="$dist" bs=1M count=0 seek=4096
	fi
	mkfs.ext4 "$dist"
	mount -o loop "$dist" "$(ls -d "$builddir")"
fi

mv *.apk tmp/
apk --arch "$arch" \
	--root "$builddir" \
	--no-cache \
	-U --allow-untrusted --progress \
	--initdb \
	add tmp/*.apk

cp chroot.sh "$builddir"/

SHELL=/bin/sh chroot "$builddir"/ /chroot.sh || cmderr

# cp -r gearlock/src/* "$builddir"/
rm -rf \
	"$builddir"/chroot.sh \
	"$builddir"/bin \
	"$builddir"/lib \
	"$builddir"/sbin \
	"$builddir"/usr/sbin
ln -s usr/lib "$builddir"/lib
ln -s usr/bin "$builddir"/bin
ln -s usr/bin "$builddir"/sbin
ln -s bin "$builddir"/usr/sbin
mkdir -p "$builddir"/usr/lib/modules "$builddir"/usr/lib/firmware

if [ "$use" = "squashfs" ]; then
	mksquashfs "$builddir" "$dist" -comp "$comp" -no-duplicates -no-recovery -always-use-fragments "$@" >/dev/null 2>&1 || cmderr
else
	outfile=$(readlink -f "$dist")
	if [ "$use" = "img" ]; then
		umount -r "$builddir"
	else
		cd "$builddir" || cderr "$builddir"
		eval "find . | cpio --create --format='newc' | $comp $* > $outfile" >/dev/null 2>&1 || cmderr
		cd ..
	fi
	cd "$PWD" || cderr "$PWD"
fi
