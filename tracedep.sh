#!/bin/bash

declare -a apk_cmd=(apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main/
	-X https://dl-cdn.alpinelinux.org/alpine/edge/community/
	-X ~/packages/gearbuild/x86_64/
	--arch x86_64 -U --no-cache info)

apk_filter() {
	${apk_cmd[@]} --who-owns "$1" 2>/dev/null | grep -Ev "^fetch " | awk -F ' is owned by ' '{print $2}' | sed -r 's/-([0-9]+\.)*[0-9]+-r[0-9]+$//g'
}

deplist() {
	while read -r line; do
		[ "$line" ] || continue
		line=${line%%=*}
		case "$line" in
		so:*)
			sopkg=$(apk_filter "/lib/${line#so:}" | apk_filter "/usr/lib/${line#so:}")
			[ "$sopkg" ] && line=$sopkg
			;;
		esac
		grep -Ewq "^$line$" ./pkglist.txt && continue
		echo "$line"
		deplist "$line"
	done < <(${apk_cmd[@]} -R "$1" 2>/dev/null | grep -Ev "fetch |depends on:") | sort -u
}
