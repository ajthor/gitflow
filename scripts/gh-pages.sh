#!/bin/sh

USAGE="usage: gitflow gh-pages [-c | --commit]\n\n"

firstcommit=0
branch_exists=0

while test $# != 0
do

	case "$1" in
		-c | --commit)
			firstcommit=1
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

# Check if Gh-Pages Branch Exists
# -------------------------------
if git show-ref --verify -q refs/heads/gh-pages; then
	branch_exists=1
fi

if [ "$branch_exists" -eq 1 ]; then
	printf "Error: gh-pages branch already exists.\n"
else

	has_remote=$(git ls-remote ${remoteUrl} &> /dev/null)
	if [ -n "$has_remote" ]; then
		has_remote=1
	else
		has_remote=0
	fi
	
	# Create Gh-Pages Branch
	# ----------------------
	git checkout master &&
	git checkout --orphan gh-pages &&
	git rm -rf .

	if [[ $firstcommit ]]; then
		echo "Docs coming soon." > index.html &&
		git add index.html &&
		git commit -a -m "initial gh-pages commit"
	fi

	if [ "$has_remote" -eq 1 ]; then
		git push
	fi
fi


