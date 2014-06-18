# Contributing

I am always appreciative of contributions or feedback of any kind. I appreciate issue reports, suggestions, and epecially pull requests :-)

Please follow these general guidelines for submissions if you contribute.

## Style Guide

Please follow the code conventions I use in my projects. I know they are not always universally loved, but I would prefer to follow them in my projects. I use [smart tabs](http://www.emacswiki.org/emacs/SmartTabs), multiple var statements, single-quotes, and very general linting options.

## Pull Requests

I do not usually include my unit tests on GitHub. It's a terrible habit which I hope to break in the near future, but my coding style and workflow are so chaotic that it's hard to keep all of my unit tests in order on my private projects. Soon, I hope to manage this using a new tool I have created, [Inkblot](https://github.com/ajthor/inkblot). If a test suite exists in the `test` directory for the file you wish to modify, please include a unit test in the respective spec to test the behavior you are modifying.

Keep the number of commits to a *minimum*, please. It's a bit of a double standard seeing as I am so commit-happy, but I would like single commits or squashed commits in pull requests, please. 

### Commit Messages

Use the following headers when committing. I use CRUD + add conventions for my messages, so just keep those in mind and you should be golden.
```
add: (message) - used for adding files/features/etc.
remove:        - used for removing features or (temporarily) files
update:        - for things like package.json dependency updates
create:        - for new files
delete:        - for permanent deletion
lint:          
style:         - cosmetic changes
refactor:      - re-writing code
fix:           - fixing errors
```
For the message, please use *present* tense with no 3rd-person -s or continuous -ing suffixes. Meaning:

`add: grunt task` is OK.
`adds: grunt task` is NOT OK.
`added: grunt task` is NOT OK.
`adding: grunt task` is NOT OK.

## Issue Submission

1. Please make sure you have the latest versions of everything before submitting an issue. Run `npm cache clean` and `npm update` and try again if you haven't already.
2. Be sure to include plenty of information so that your issue can be recreated. 
3. __Make sure that no other similar issues already exist.__