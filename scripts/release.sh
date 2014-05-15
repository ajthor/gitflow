#!/bin/sh

USAGE="usage: gitflow release <semver_tag> [-d | --delete] [-m | --merge]\n\n"

delete=0
merge=0

remoteUrl=
has_remote=0

version=
branch=

branch_exists=0
tag_exists=0

while test $# != 0
do

	case "$1" in
		-d | --delete)
			delete=1
			;;
		-m | --merge)
			merge=1
			;;
		v*.*.*)
			version="$1"
			branch="release-$1"
			;;
		-h | --help)
			printf "${USAGE}"
			exit 0
			;;
		*)
			printf "Unknown option.\n"
			printf "${USAGE}"
			exit 1
			;;
	esac
	shift

done

# Exit if no tag supplied.
if [ -z "$branch" ]; then
	printf "Must supply a <semver_tag> to release command.\n"
	exit 1
fi

# Release Branch
# ==============

# Check if Release Branch Exists
# ------------------------------
if git show-ref --verify -q refs/heads/"$branch"; then
	branch_exists=1
fi
# Check if Tag Exists
# -------------------
if git show-ref --verify -q refs/tags/"$version"; then
	tag_exists=1
fi

if [ "$branch_exists" -eq 1 ]; then

	git stash

	# Merge Branch
	# ------------
	# Merge release branch into master and development, tagging the 
	# release as you go.
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

		printf "Tag: $version"
		git tag -a "$version"
		
		if [ "$has_remote" -eq 1 ]; then
			git push
			git push --tags
		fi

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
	if [[ $delete ]]; then
		printf "Delete: $branch\n"
		git branch -d "$branch"
	else
		git checkout "$branch"
	fi

else
	# Create release Branch
	# ---------------------
	# If tag does not exist, create release branch.
	if [ "$tag_exists" -eq 1 ]; then
		printf "Error: tag already exists. Please choose another tag.\n"
	else
		printf "Create: release branch $branch\n"
		git checkout -b "$branch" development
	fi
fi


