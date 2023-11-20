#!/bin/bash

. .rc

while [[ "$1" ]]; do
	case "$1" in
	-a | --arch) [ -z "$2" ] && argerr "$1" || arch="$2" ;;
	-m | --mirror) [ -z "$2" ] && argerr "$1" || mirror="$2" ;;
	-b | --branch) [ -z "$2" ] && argerr "$1" || branch="$2" ;;
	-d | --builddir) [ -z "$2" ] && argerr "$1" || builddir="$2" ;;
	-t | --tmpdir) [ -z "$2" ] && argerr "$1" || tmpdir="$2" ;;
	-p | --pkglist) [ -z "$2" ] && argerr "$1" || pkglist="$2" ;;
	*) break ;;
	esac
	shift 2
done

rm -rf tmp
mkdir -p tmp

# tar -C build -xzvf build.tar.gz >/dev/null 2>&1 || cmderr

[ -z "$mirror" ] && read -rp "Enter mirror (default: https://dl-cdn.alpinelinux.org/alpine): " mirror
mirror=${mirror:-"https://dl-cdn.alpinelinux.org/alpine"}

[ -z "$branch" ] && read -rp "Enter branch (default: latest-stable): " branch
branch=${branch:-latest-stable}

[ -z "$arch" ] && read -rp "Enter architecture: (default: x86): " arch
arch=${arch:-x86}

builddir=${builddir:-./build}
echo "Build directory is $builddir"

tmpdir=${tmpdir:-./tmp}
echo "Temp directory is $tmpdir"

pkglist=${pkglist:-./pkglist.txt}
echo "Using package list $pkglist"

# build gearlock
cd gearlock
abuild -Ff
cd ..
cp "$(ls ~/packages/*/$arch/gearlock-*.apk | head -1)" tmp/

export mirror branch arch builddir tmpdir pkglist

for cmd in sudo doas pkexec; do
	if [ "$(command -v $cmd)" ]; then
		$cmd /usr/bin/env \
			mirror="$mirror" \
			branch="$branch" \
			arch="$arch" \
			builddir="$builddir" \
			tmpdir="$tmpdir" \
			pkglist="$pkglist" \
			./build.sh $@
		exit $?
	fi
done
