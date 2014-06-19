#!/bin/sh

USAGE="usage: gitflow feature <branch_name> [-d | --delete] [-m | --merge]\n\n"

delete=0
merge=0

remoteUrl=
has_remote=0

branch=

while test $# != 0
do

	case "$1" in
		-d | --delete)
			delete=1
			;;
		-m | --merge)
			merge=1
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
			# if [ -n "${branch#release*}" ] || [ -n "${branch#issue*}"]; then
			# 	printf "ERROR: Cannot use branch names that begin with \'release\' or \'issue\'.\n"
			# 	printf "Use the \'gitflow release\' or \'gitflow patch\' command.\n"
			# 	exit 1
			# fi
			;;
	esac
	shift

done

# Exit if no branch name specified.
if [ -z "$branch" ]; then
	printf "Must supply a <branch_name> to feature command.\n"
	exit 1
fi

# Feature Branch
# ==============

# Check if feature branch exists. If it does, then either merge it,
# delete it, or check it out.
if git show-ref --verify -q refs/heads/"$branch"; then

	if [ "$merge" -eq 1 ]; then
		gitflow merge "$branch"
	fi

	

	if [ "$delete" -eq 1 ]; then
		gitflow delete "$branch"
	else
		git checkout "$branch"
	fi

else
	# If the branch doesn't exist, create a feature branch.
	printf "Create: feature branch $branch\n"
	git checkout -b "$branch" origin/development
fi



