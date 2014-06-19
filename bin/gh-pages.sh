#!/bin/sh

USAGE="usage: gitflow gh-pages [-c | --commit]\n\n"

remoteUrl=
has_remote=0

first_commit=0
branch_exists=0

while test $# != 0
do

	case "$1" in
		-c | --commit)
			first_commit=1
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

# Gh-Pages Branch
# ===============

# Check if Gh-Pages branch exists.
if git show-ref --verify -q refs/heads/gh-pages; then
	printf "Error: gh-pages branch already exists.\n"
else

	# Check if the remote repository exists.
	remoteUrl=$(git ls-remote --get-url)
	if git ls-remote --exit-code "$remoteUrl" HEAD &> /dev/null; then
		has_remote=1
	fi
	
	# Create Gh-Pages branch.
	git checkout master &&
	git checkout --orphan gh-pages &&
	git rm -rf .

	if [ "$first_commit" -eq 1 ]; then
		echo "Docs coming soon." > index.html &&
		git add index.html &&
		git commit -a -m "initial gh-pages commit"
	fi

	if [ "$has_remote" -eq 1 ]; then
		git push
	fi
fi


