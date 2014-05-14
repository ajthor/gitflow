#!/bin/sh

USAGE="usage: gitflow release <semver_tag> [-d | --delete] [-m | --merge]\n\n"

delete=0
merge=0

remoteUrl=
has_remote=0

version=
branch=

branch_exists=0

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

if [ -z "$branch" ]; then
	printf "Must supply a <semver_tag> to release command.\n"
	exit 1
else
	git checkout -b "$branch" development
fi

if [[ $merge ]]; then
	#statements
	printf "Merge: master .. $branch\n"
	git pull origin master &&
	git checkout master &&
	git merge --no-ff "$branch" &&
	git push

	printf "Tag: $version"
	git tag -a "$version" &&
	git push --tags

	printf "Merge: development .. $branch\n"
	git pull origin development &&
	git checkout development &&
	git merge --no-ff "$branch" &&
	git push 
fi

if [[ $delete ]]; then
	printf "Delete: $branch\n"
	git branch -d "$branch"
fi


