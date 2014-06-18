#!/bin/sh

USAGE="usage: gitflow init [-c | --commit] [-g | --gh-pages] [<remote_url>]\n\n"

ghpages=0
remoteUrl=

firstcommit=0

has_dev_branch=0
has_master_branch=0

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
			firstcommit=1
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

	# Set Up Remote
	# -------------
	if [ -n "$remote_url" ]; then
		git remote add origin "$remoteUrl"

		# Check if remote exists.
		has_remote=$(git ls-remote ${remoteUrl} &> /dev/null)
		git ls-remote ${remoteUrl} &> /dev/null
		if [ -n "$has_remote" ]; then
			has_remote=1
		fi
	fi

	# Make First Commit
	# -----------------
	# If the 'firstcommit' flag is set, then make a first commit to 
	# the repo, even if it's an empty commit.
	if [ "$firstcommit" -eq 1 ]; then
		git add . &&
		git commit -a --allow-empty --quiet -m "initial commit"

		if [ "$has_remote" -eq 1 ]; then
			git push origin master
		fi
	fi

	# Create Development Branch
	# -------------------------
	# Create the development branch (we know it doesn't exist yet) 
	# and make an empty commit to it.
	git checkout master &&
	git checkout -b development origin/master &&
	git commit --allow-empty --quiet -m "initial development commit"

	# Push Development to Remote
	# --------------------------
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

	# Set Up Remote
	# -------------
	# If the remote repo isn't set up properly, set it up now.
	if [ -z "$remoteUrl" ]; then
		remoteUrl=$(git config --get remote.origin.url)
	fi

	if [ -z "$remoteUrl" ]; then
		has_remote=$(git ls-remote ${remoteUrl} &> /dev/null)
		git ls-remote ${remoteUrl} &> /dev/null
		if [ -n "$has_remote" ]; then
			$has_remote=1
			git fetch
		fi
	fi

	# Create master Branch
	# --------------------
	# Create master if it doesn't exist.
	if git show-ref --verify -q refs/heads/master; then
		has_master_branch=1
	fi
	if [ "$has_master_branch" -eq 1 ]; then
		git checkout -b master
		git update-ref HEAD master

		git commit --allow-empty --quiet -m "initial commit"

		if [ "$has_remote" -eq 1 ]; then
			git push origin master
		fi
	fi

	# Create Development Branch
	# -------------------------
	# Create development branch if it doesn't exist. If it does, 
	# check out the development branch.
	if git show-ref --verify -q refs/heads/development; then
		has_dev_branch=1
	fi
	if [ "$has_dev_branch" -eq 0 ]; then
		git checkout -b development origin/master

		if [ "$has_remote" -eq 1 ]; then
			git push -u origin development
		fi
	else 
		git checkout development
	fi

	# Set Up Remote Head
	# ------------------
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
	if [ $firstcommit -eq 1 ]; then
		sh ./gh-pages.sh -c
	else
		sh ./gh-pages.sh
	fi
fi

