#!/bin/sh

USAGE="usage: gitflow patch <issue_number> [-d | --delete] [-m | --merge]\n\n"

delete=0
merge=0

remoteUrl=
has_remote=0

branch_exists=0

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

# Patch Branch
# ============

# Check if Branch Exists
# ----------------------
if git show-ref --verify -q refs/heads/"$branch"; then
	branch_exists=1
fi

if [ "$branch_exists" -eq 1 ]; then

	git stash

	# Merge Branch
	# ------------
	# Make sure destination exists and then merge the patch branch 
	# into it.
	if [ "$merge" -eq 1 ]; then

		has_remote=$(git ls-remote ${remoteUrl} &> /dev/null)
		if [ -n "$has_remote" ]; then
			has_remote=1
		else
			has_remote=0
		fi

		printf "Merge: master .. $branch\n"

		if [ "$has_remote" -eq 1 ]; then
			git pull origin master
			git pull origin development
			git pull origin "$branch"
		fi

		git checkout master &&
		git merge --no-ff "$branch"

		if [ "$has_remote" -eq 1 ]; then
			git push
		fi

		# Create tag for patch.

		printf "Merge: development .. $branch\n"

		git checkout development &&
		git merge --no-ff "$branch"

		if [ "$has_remote" -eq 1 ]; then
			git push
		fi

	fi

	# Delete Branch
	# -------------
	# If the delete flag is passed, delete the branch. Otherwise, 
	# check out the branch.
	if [ "$delete" -eq 1 ]; then
		printf "Delete: $branch\n"
		git branch -d "$branch"
	else
		git checkout "$branch"
	fi

else
	# Create Patch Branch
	# -------------------
	printf "Create: issue branch $branch\n"
	git checkout -b "$branch" development
fi

