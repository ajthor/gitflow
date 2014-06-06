#!/bin/sh

USAGE="usage: gitflow feature <branch_name> [-d | --delete] [-m | --merge] [<destination_branch>]\n\n"

delete=0
merge=0

remoteUrl=
has_remote=0

branch_exists=0
dest_exists=0

branch=
dest="development"

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
			dest="${1:-development}"
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

# Check if Feature Branch Exists
# ------------------------------
if git show-ref --verify -q refs/heads/"$branch"; then
	branch_exists=1
fi

if [ "$branch_exists" -eq 1 ]; then

	git stash

	# Merge Branch
	# ------------
	# Make sure destination exists and then merge the feature branch 
	# into it.
	if [ "$merge" -eq 1 ]; then
		if git show-ref --verify -q refs/heads/"$dest"; then
			dest_exists=1
		else
			printf "Destination branch must exist.\n"
			exit 1
		fi

		has_remote=$(git ls-remote ${remoteUrl} &> /dev/null)
		if [ -n "$has_remote" ]; then
			has_remote=1
		else
			has_remote=0
		fi

		printf "Merge: $dest .. $branch\n"
		
		if [ "$has_remote" -eq 1 ]; then
			git pull origin "$dest"
			git pull origin "$branch"
		fi
		
		git checkout "$dest" &&
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
		git checkout development
		git branch -d "$branch"
	else
		git checkout "$branch"
	fi

else
	# Create Feature Branch
	# ---------------------
	printf "Create: feature branch $branch\n"
	git checkout -b "$branch" development
fi



