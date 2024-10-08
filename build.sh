#!/bin/bash

err() { echo -e "ERROR: $1 !" && exit 1; }
argerr() { err "Cannot set $1 to empty"; }
cmderr() { err "Command failed"; }
cderr() { err "Path $1 is not found"; }

if (($(id -u) != 0)); then
	# shellcheck disable=SC2068
	if [ "$(command -v sudo)" ]; then
		sudo "$0" $@
	elif [ "$(command -v doas)" ]; then
		doas "$0" $@
	else
		err "Please run this command as root"
	fi
	exit 1

fi

while [[ "$1" ]]; do
	case "$1" in
	-a | --arch) [ -z "$2" ] && argerr "$1" || arch="$2" ;;
	-m | --mirror) [ -z "$2" ] && argerr "$1" || mirror="$2" ;;
	-b | --branch) [ -z "$2" ] && argerr "$1" || branch="$2" ;;
	-d | --builddir) [ -z "$2" ] && argerr "$1" || builddir="$2" ;;
	-o | --dist) [ -z "$2" ] && argerr "$1" || dist="$2" ;;
	*) break ;;
	esac
	shift 2
done

[ -z "$mirror" ] && read -rp "Enter mirror (default: https://dl-cdn.alpinelinux.org/alpine): " mirror
mirror=${mirror:-"https://dl-cdn.alpinelinux.org/alpine"}

[ -z "$branch" ] && read -rp "Enter branch (default: latest-stable): " branch
branch=${branch:-latest-stable}

[ -z "$arch" ] && read -rp "Enter architecture: (default: x86): " arch
arch=${arch:-x86}

builddir=${builddir:-./build}
echo "Build directory is $builddir"

[ "$dist" ] || dist=./dist/installer.sfs
echo "Generate to $dist"

PWD=$(pwd)

rm -rf build
mkdir -p build

# shellcheck disable=SC2046,SC2154,SC1001,SC2086,SC2002
grep -Ev '^#' pkglist.txt | xargs apk --arch "$arch" \
	--root "$builddir" \
	$(for repo in $(cat apk/repositories) "$mirror/$branch/main" "$mirror/$branch/community"; do echo \-X "$repo"; done) \
	--no-cache \
	-U --allow-untrusted --progress \
	--initdb \
	add

cp chroot.sh userchroot.sh "$builddir"

SHELL=/bin/sh chroot "$builddir" /chroot.sh

rm -rf "$builddir"/chroot.sh "$builddir"/userchroot.sh

