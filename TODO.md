# Gitflow TODO

## Roadmap

I hope in the future to add support for more complex workflows and to make Gitflow work with any workflow no matter how you choose to call the commands. What I mean is, I hope that if you have a feature-branch developer working with a gitflow developer that they can use a basic set of commands to collaborate on a project without stepping on each other's toes.

Future releases should add more commands to the gitflow repertoire, as well as more options. Slowly, the bash scripts should also be migrated to C code, so as to increase the portability, reduce access issues, and possibly increase the speed a little.

## TODO

- bump.c - Add code to bump the version for release and issue/hotfix branches. Perhaps it is time to incorporate the semver.c file which is for now just sitting there.
- init.sh - fix the initialization script to also use the git configuration.
- git hooks - add hooks to certain git processes to increase productivity.
- C migration - migrate shell scripts to C code (long-term)
