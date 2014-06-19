#!/bin/sh

USAGE="usage: gitflow release <semver_tag> [-d | --delete] [-m | --merge]\n\n"

delete=0
merge=0

remoteUrl=
has_remote=0

version=
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
		v*.*.*)
			version="$1"
			branch="release-$1"
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

# Check if release branch exists. If it does, then either merge it,
# delete it, or check it out.
if git show-ref --verify -q refs/heads/"$branch"; then

	if [ "$merge" -eq 1 ]; then

		# Check if the remote repository exists.
		remoteUrl=$(git ls-remote --get-url)
		if git ls-remote --exit-code "$remoteUrl" HEAD &> /dev/null; then
			has_remote=1
		fi

		gitflow merge "$branch" master

		printf "Tag: $version"
		git tag -a "$version"
		
		if [ "$has_remote" -eq 1 ]; then
			git push --tags
		fi

		gitflow merge "$branch" development

	fi

	

	if [ "$delete" -eq 1 ]; then
		gitflow delete "$branch"
	else
		git checkout "$branch"
	fi

else
	# If the tag already exists, then throw an error.
	if git show-ref --verify -q refs/tags/"$version"; then
		printf "Error: Tag already exists. Please choose another tag.\n"
		exit 1
	# If the branch doesn't exist, create a release branch.
	else
		printf "Create: release branch $branch\n"
		git checkout -b "$branch" development
	fi
fi


