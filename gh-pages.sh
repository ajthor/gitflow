#!/bin/sh

USAGE="gitflow gh-pages [-c | --commit]"

firstcommit=

while test $# != 0
do

	case "$1" in
		-c | --commit)
			firstcommit=1
			;;
		-h | --help | *)
			printf "Unknown option.\n"
			printf "${USAGE}"
	esac
	shift

done

git checkout master &&
git checkout --orphan gh-pages

if [[ $firstcommit ]]; then
	git rm -rf . &&
	echo "Docs coming soon." > index.html &&
	git add index.html &&
	git commit -a -m "initial gh-pages commit"
fi

git push origin gh-pages