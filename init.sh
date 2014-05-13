#!/bin/sh

USAGE="gitflow init [-c | --commit] [-g | --gh-pages] <remote_url>"

ghpages=
remoteUrl=

firstcommit=

while test $# != 0
do

	case "$1" in
		-h | --help)
			printf "Unknown option.\n"
			printf "${USAGE}"
			;;
		-g | --gh-pages)
			ghpages=1
			;;
		-c | --commit)
			firstcommit=1
			;;
		https://*.git | git@*.git)
			remoteUrl="$1"
	esac
	shift

done

git init &&
git remote add origin "$remoteUrl"

if [[ $firstcommit ]]; then
	# Make first commit.
	git add .
	git commit -a -m "initial commit"

	git push origin master
fi

if [[ $ghpages ]]; then
	# Run gh-pages command.
	if [[ $firstcommit ]]; then
		sh ./gh-pages.sh -c
	else
		sh ./gh-pages.sh
	fi
fi