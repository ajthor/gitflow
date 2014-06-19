#!/bin/sh

USAGE="usage: gitflow merge [<branch>] [<destination_branch>]\n\n"

remoteUrl=
has_remote=0

branch=
dest="development"

branch_exists=0
dest_exists=0

tag_exists=0

while test $# != 0
do
	
	case "$1" in
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
			;;
	esac
	shift

done

# Merge Branch
# ============

# If no branch is specified, use the current branch.
if [ -z "$branch" ]; then
	branch=$(git rev-parse --abbrev-ref HEAD)
fi

if git show-ref --verify -q refs/heads/"$branch"; then

	# Check if the remote repository exists.
	remoteUrl=$(git ls-remote --get-url)
	if git ls-remote --exit-code "$remoteUrl" HEAD &> /dev/null; then
		has_remote=1
	fi

	# Make sure destination exists and then merge the feature branch 
	# into it.
	if git show-ref --verify -q refs/heads/"$dest"; then
		dest_exists=1
	else
		printf "Destination branch must exist.\n"
		exit 1
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

else
	printf "Branch does not exist.\n"
	printf "${USAGE}"
	exit 1
fi


