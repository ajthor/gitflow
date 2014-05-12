#!/bin/sh

USAGE="gitflow feature <feature_name> [-d] [-m] [<destination_branch>]"

delete=
merge=

while test $# != 0
do

	case "$1" in
	-d)
		delete=1
		;;
	-m)
		merge=1
		;;
	*)
		echo ${USAGE}
		;;
	esac
	shift

done

if [[ $merge ]]; then
	#statements
	echo "merge"
fi

if [[ $delete ]]; then
	#statements
	echo "delete"
fi