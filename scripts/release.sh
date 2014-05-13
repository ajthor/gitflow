#!/bin/sh

USAGE="gitflow release <semver_tag> [-d | --delete] [-m | --merge]"

delete=
merge=

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
		v*.*.*)
			version="$1"
			branch="release-$1"
			;;
		-h | --help)
			printf "Unknown option.\n"
			printf "${USAGE}"
			;;
	esac
	shift

done

if [ -z branch ]; then
	printf "Must supply a <version> to release command."
	exit 1
else
	git checkout -b "$branch" development
fi

if [[ $merge ]]; then
	#statements
	printf "Merge: $branch .. master"
	git pull origin master &&
	git checkout master &&
	git merge --no-ff "$branch" &&
	git push

	printf "Tag: $version"
	git tag -a "$version" &&
	git push --tags

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


