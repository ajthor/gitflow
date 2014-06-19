#!/bin/sh

USAGE="usage: gitflow patch <issue_number> [-d | --delete] [-m | --merge]\n\n"

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
			branch="issue-#${1#issue-*}"
			;;
	esac
	shift

done

# Exit if no branch name specified.
if [ -z "$branch" ]; then
	printf "Must supply an <issue_number> to issue command.\n"
	exit 1
fi

# Patch Branch
# ============

# Check if issue branch exists. If it does, then either merge it,
# delete it, or check it out.
if git show-ref --verify -q refs/heads/"$branch"; then

	if [ "$merge" -eq 1 ]; then

		gitflow merge "$branch" master
		# Create tag for patch.

		gitflow merge "$branch" development

	fi

	

	if [ "$delete" -eq 1 ]; then
		gitflow delete "$branch"
	else
		git checkout "$branch"
	fi

else
	# If the branch doesn't exist, create an issue branch.
	printf "Create: issue branch $branch\n"
	git checkout -b "$branch" origin/development
fi

