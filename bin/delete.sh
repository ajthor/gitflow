#!/bin/sh

USAGE="usage: gitflow delete [<branch>]\n\n"

remoteUrl=
has_remote=0

branch=
branch_exists=0

while test $# != 0
do
	
	case "$1" in
		development | master)
			printf "Cannot delete 'devlopment' or 'master' branches."
			exit 1
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

# Delete Branch
# =============

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

	# Delete the branch from local and remote.
	printf "Delete: $branch\n"
	
	git checkout development
	git branch -d "$branch"

	if [ "$has_remote" -eq 1 ]; then
		git push origin --delete "$branch"
	fi

else
	printf "Branch does not exist.\n"
	printf "${USAGE}"
	exit 1
fi


