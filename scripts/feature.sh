#!/bin/sh

USAGE="gitflow feature <branch_name> [-d | --delete] [-m | --merge] [<destination_branch>]\n\n"

delete=
merge=

branch=
dest=

while test $# != 0
do

	case "$1" in
		-d | --delete)
			delete=1
			;;
		-m | --merge)
			merge=1
			;;
		dev | develop | development | master)
			dest="$1"
			;;
		-h | --help)
			printf "${USAGE}"
			exit 0
			;;
		-*)
			printf "Unknown option.\n"
			printf "${USAGE}"
			exit 1
			;;
		*)
			branch="$1"

			if [ -n "${branch#release*}" ] || [ -n "${branch#issue*}"]; then
				printf "ERROR: Cannot use branch names that begin with \'release\' or \'issue\'.\n"
				printf "Use the \'gitflow release\' or \'gitflow patch\' command.\n"
				exit 1
			fi
			# Is branch a branch that currently exists?
			;;
	esac
	shift

done

if [ -z "$branch" ]; then
	printf "Must supply a <branch_name> to feature command."
	exit 1
else
	git checkout -b "$branch" development
fi

if [[ $merge ]]; then
	printf "Merge: $branch .. development"
	git pull origin development &&
	git checkout development &&
	git merge --no-ff "$branch" &&
	git push
fi

if [[ $delete ]]; then
	printf "Delete: $branch"
	git branch -d "$branch"
fi


