#!/bin/sh

USAGE="gitflow feature <branch_name> [-d] [-m] [<destination_branch>]"

delete=
merge=

branch=
dest=

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
			# Is branch a branch that currently exists?
	esac
	shift

done

if [ -z branch ]; then
	echo "Must supply a <branch_name> to feature command."
	exit 1
else
	echo $branch
fi

if [[ $merge ]]; then
	#statements
	echo "merge"
fi

if [[ $delete ]]; then
	#statements
	echo "delete"
fi