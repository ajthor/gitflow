#!/bin/sh

USAGE="usage: gitflow patch <issue_number> [-d] [-m]\n\n"

delete=
merge=

branch=

while test $# != 0
do

	case "$1" in
		-h | --help)
			printf "Unknown option.\n"
			printf "${USAGE}"
			;;
		-d | --delete)
			delete=1
			;;
		-m | --merge)
			merge=1
			;;
		*)
			branch="$1"
			;;
	esac
	shift

done

echo "issue: $branch"

if [[ $merge ]]; then
	#statements
	echo "merge"
fi

if [[ $delete ]]; then
	#statements
	echo "delete"
fi