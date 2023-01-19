#!/bin/bash

. .rc

ckroot

while [[ "$1" ]]; do
	case "$1" in
	-c | --compression) [ -z "$2" ] && argerr "$1" || comp="$2" ;;
    -d | --builddir) [ -z "$2" ] && argerr "$1" || builddir="$2" ;;
    -o | --dist) [ -z "$2" ] && argerr "$1" || dist="$2" ;;
	esac
	shift
	shift
done
PWD=$(pwd)

if [ -z "$comp" ]; then
	comp=gzip
	read -s -p "Enter compression program: (default: gzip)" comp
fi

[ "$builddir" ] || builddir=./build
echo "Build directory is $builddir"

[ "$dist" ] || dist=./dist/gearlock
echo "Generate to $dist"

outfile=$(readlink -f "$dist")

cd "$builddir" || cderr "$builddir"

eval "find . | cpio --create --format='newc' | $comp > $outfile" || cmderr

cd "$PWD" || cderr "$PWD"
