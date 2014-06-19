#!/bin/sh

USAGE="usage: gitflow init [-c | --commit] [-g | --gh-pages] [<remote_url>]\n\n"

ghpages=0
remoteUrl=

first_commit=0

has_git_directory=0

has_remote=0

branch=

while test $# != 0
do

	case "$1" in
		-g | --gh-pages)
			ghpages=1
			;;
		-c | --commit)
			first_commit=1
			;;
		https://*.git | git@*.git | ssh://*.git | *.git)
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

# Initialize New Repo
# ===================

# Check if .git directory exists--and if it does not, initialize a 
# new, local Git repo with all of the requisite branches.
has_git_directory=$(git rev-parse -q --git-dir 2> /dev/null)

if [ ! `git rev-parse -q --git-dir 2> /dev/null` ]; then

	# Initialize Git Repo
	# -------------------

	# Set up Git directory and initialize the master branch.
	git init

	# Set up remote
	if [ -n "$remote_url" ]; then
		git remote add origin "$remoteUrl"

		# Check if remote exists.
		if git ls-remote --exit-code "$remoteUrl" HEAD &> /dev/null; then
			has_remote=1
		fi
	fi

	# If the 'first_commit' flag is set, then make a first commit to 
	# the repo, even if it's an empty commit.
	if [ "$first_commit" -eq 1 ]; then
		git add . &&
		git commit -a --allow-empty --quiet -m "initial commit"

		if [ "$has_remote" -eq 1 ]; then
			git push origin master
		fi
	fi

	# Create the development branch (we know it doesn't exist yet) 
	# and make an empty commit to it.
	git checkout master &&
	git checkout -b development origin/master &&
	git commit --allow-empty --quiet -m "initial development commit"

	# Push the 'development' branch to remote and set the development 
	# branch as the integration branch.
	if [ "$has_remote" -eq 1 ]; then
		git push origin development
		git remote set-head origin development
		git remote show origin
	fi

# Initialize Existing Repo
# ========================

# If the .git directory already exists, check that the repo has all 
# of the necessary branches for GitFlow. If not, create them.
else

	# If the remote repo isn't set up properly, set it up now.
	if [ -z "$remoteUrl" ]; then
		remoteUrl=$(git ls-remote --get-url)
		if git ls-remote --exit-code "$remoteUrl" HEAD &> /dev/null; then
			has_remote=1
			git fetch
		fi
	fi

	# Create master if it doesn't exist.
	if [ ! `git show-ref --verify -q refs/heads/master` ]; then
		git checkout -b master
		git update-ref HEAD master

		git commit --allow-empty --quiet -m "initial commit"

		if [ "$has_remote" -eq 1 ]; then
			git push origin master
		fi
	fi

	# Create development branch if it doesn't exist. If it does, 
	# check out the development branch.
	if [ ! `git show-ref --verify -q refs/heads/development` ]; then
		git checkout -b development origin/master

		if [ "$has_remote" -eq 1 ]; then
			git push -u origin development
		fi
	else 
		git checkout development
	fi

	# Set up remote head.
	if [ "$has_remote" -eq 1 ]; then
		git remote set-head origin development
		git remote show origin
	fi

fi

# Gh-Pages
# ========
# If gh-pages flag is set, then run the command.
if [ "$ghpages" -eq 1 ]; then
	# Run gh-pages command.
	if [ $first_commit -eq 1 ]; then
		gitflow gh-pages -c
	else
		gitflow gh-pages
	fi
fi

