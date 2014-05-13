#!/bin/sh

USAGE="gitflow gh-pages [-c | --commit]\n\n"

firstcommit=

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

git checkout master &&
git checkout --orphan gh-pages &&
git rm -rf .

if [[ $firstcommit ]]; then
	echo "Docs coming soon." > index.html &&
	git add index.html &&
	git commit -a -m "initial gh-pages commit"
fi

git push origin gh-pages

git checkout development


