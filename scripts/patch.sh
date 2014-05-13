#!/bin/sh

USAGE="usage: gitflow patch <issue_number> [-d | --delete] [-m | --merge]\n\n"

delete=
merge=

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
		*)
			branch="issue-#${1#issue-*}"
			;;
		-h | --help)
			printf "Unknown option.\n"
			printf "${USAGE}"
			;;
	esac
	shift

done

echo "issue: $branch"

if [[ $merge ]]; then
	printf "Merge: $branch .. master"
	git checkout master &&
	git merge --no-ff "$branch" &&
	git push

	# Create tag for patch.

	printf "Merge: $branch .. development"
	git checkout development &&
	git merge --no-ff "$branch" &&
	git push
fi

if [[ $delete ]]; then
	printf "Delete: $branch"
	git branch -d "$branch"
fi


