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
		dev | develop | development | master)
			dest="$1"
			;;
		*)
			branch="$1"
			# Is branch a branch that currently exists?
			;;
	esac
	shift

done

if [ -z branch ]; then
	echo "Must supply a <branch_name> to feature command."
	exit 1
else
	git checkout -b "$branch" development
fi

if [[ $merge ]]; then
	#statements
	echo "Merge: $branch .. develop"
	git pull origin develop &&
	git checkout develop &&
	git merge "$branch" &&
	git push &&
	git branch -d "$branch"
fi

if [[ $delete ]]; then
	#statements
	echo "delete"
fi


