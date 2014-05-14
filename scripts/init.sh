#!/bin/sh

USAGE="usage: gitflow init [-c | --commit] [-g | --gh-pages] <remote_url>\n\n"

ghpages=0
remoteUrl=

firstcommit=

has_dev_branch=0
has_master_branch=0

has_remote=0

branch=

while test $# != 0
do

	case "$1" in
		-g | --gh-pages)
			ghpages=1
			;;
		-c | --commit)
			firstcommit=1
			;;
		https://*.git | git@*.git | ssh://*.git)
			remoteUrl="$1"
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
	esac
	shift

done

# Check if .git directory exists--and if it does not, initialize a 
# new, local Git repo with all of the requisite branches.
if [ ! `git rev-parse -q --git-dir` ]; then

	git init

	if [ -n "$remote_url" ]; then
		git remote add origin "$remoteUrl"

		# Check if remote exists.
		has_remote=$(git ls-remote ${remoteUrl} &> /dev/null)
		git ls-remote ${remoteUrl} &> /dev/null
		if [ -n "$has_remote" ]; then
			$has_remote=1
		fi
	fi

	# If the 'firstcommit' flag is set, then make a first commit to 
	# the repo, even if it's an empty commit.
	if [ "$firstcommit" -eq 1 ]; then
		git add . &&
		git commit -a --allow-empty --quiet -m "initial commit"

		if [ "$has_remote" -eq 1 ]; then
			git push origin master
		fi
	fi

	git checkout master &&
	git checkout -b development &&
	git commit --allow-empty --quiet -m "initial development commit"

	if [ "$has_remote" -eq 1 ]; then
		git push origin development
		git remote set-head origin development
		git remote show origin
	fi



# If the .git directory already exists, check that the repo has all 
# of the necessary branches for GitFlow. If not, create them.
else

	# Check if remote exists.
	if [ -z "$remoteUrl" ]; then
		remoteUrl=$(git config --get remote.origin.url)
	fi

	if [ -z "$remoteUrl" ]; then
		has_remote=$(git ls-remote ${remoteUrl} &> /dev/null)
		git ls-remote ${remoteUrl} &> /dev/null
		if [ -n "$has_remote" ]; then
			$has_remote=1
			git fetch
		else
			if [ -n "$remote_url" ]; then
				git remote add origin "$remoteUrl"
			fi
		fi
	fi

	# Create master if it doesn't exist.
	has_master_branch=$(git symbolic-ref -q master)
	if [[ ! "$has_master_branch" ]]; then
		git checkout -b master
		git update-ref HEAD master

		git commit --allow-empty --quiet -m "initial commit"

		if [ "$has_remote" -eq 1 ]; then
			git push origin master
		fi
	fi

	# Create development branch if it doesn't exist.
	has_dev_branch=$(git symbolic-ref -q development)
	if [[ ! "$has_dev_branch" ]]; then
		git checkout -b development master

		if [ "$has_remote" -eq 1 ]; then
			git push -u origin development
		fi
	else 
		git checkout development
	fi

	if [ "$has_remote" -eq 1 ]; then
		git remote set-head origin development
		git remote show origin
	fi

fi

if [ "$ghpages" -eq 1 ]; then
	# Run gh-pages command.
	if [ $firstcommit -eq 1 ]; then
		sh ./gh-pages.sh -c
	else
		sh ./gh-pages.sh
	fi
fi

