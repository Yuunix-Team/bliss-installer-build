#!/bin/bash

. .rc

ckroot

while [[ "$1" ]]; do
	case "$1" in
	-a | --arch) [ -z "$2" ] && argerr "$1" || arch="$2" ;;
	-m | --mirror) [ -z "$2" ] && argerr "$1" || mirror="$2" ;;
	-b | --branch) [ -z "$2" ] && argerr "$1" || branch="$2" ;;
	-d | --builddir) [ -z "$2" ] && argerr "$1" || builddir="$2" ;;
	-p | --pkglist) [ -z "$2" ] && argerr "$1" || pkglist="$2" ;;
	esac
	shift
	shift
done

mkdir -p build dist
tar -C build -xzvf build.tar.gz > /dev/null 2>&1 || cmderr

if [ -z "$mirror" ]; then
	mirror=https://dl-cdn.alpinelinux.org/alpine
	read -s -p "Enter mirror (default: https://dl-cdn.alpinelinux.org/alpine): " mirror
	echo ""
fi

if [ -z "$branch" ]; then
	branch=latest-stable
	read -s -p "Enter branch (default: latest-stable): " branch
	echo ""
fi

if [ -z "$arch" ]; then
	arch=x86
	read -s -p "Enter architecture: (default: x86): " arch
	echo ""
fi

[ "$builddir" ] || builddir=./build
echo "Build directory is $builddir"

[ "$pkglist" ] || pkglist=./pkglist.txt
echo "Using package list $pkglist"

apk --arch "$arch" -X "$mirror/$branch/main/" -X "$mirror/$branch/community/" -X "$(cat apk/repositories)" -U --allow-untrusted --root "$builddir"/ --initdb add - <"$pkglist" || cmderr

cp -r etc "$builddir"/
