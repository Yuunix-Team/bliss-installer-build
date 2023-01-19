#!/bin/bash

. .rc

ckroot

while [[ "$1" ]]; do
    case "$1" in
    -c | --compression) [ -z "$2" ] && argerr "$1" || comp="$2" ;;
    -d | --builddir) [ -z "$2" ] && argerr "$1" || builddir="$2" ;;
    -o | --dist) [ -z "$2" ] && argerr "$1" || dist="$2" ;;
    -s | --squashfs) use_squashfs=true ;;
    -cargs) shift; break ;;
    esac
    shift
    shift
done
PWD=$(pwd)

[ -z "$comp" ] && read -p "Enter compression program: (default: gzip): " comp
[ -z "$comp" ] && comp=gzip

[ "$builddir" ] || builddir=./build
echo "Build directory is $builddir"

[ "$dist" ] || dist=./dist/gearlock
echo "Generate to $dist"

[ -e "$dist" ] && rm -f "$dist"
if [ "$use_squashfs" = "true" ]; then
    mksquashfs "$builddir" "$dist" -comp "$comp" -no-duplicates -no-recovery -always-use-fragments $@ >/dev/null 2>&1 || cmderr
else
    outfile=$(readlink -f "$dist")
    cd "$builddir" || cderr "$builddir"
    eval "find . | cpio --create --format='newc' | $comp $@ > $outfile" >/dev/null 2>&1 || cmderr
    cd "$PWD" || cderr "$PWD"
fi
