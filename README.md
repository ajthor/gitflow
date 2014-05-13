# GitFlow

Opinionated Git workflow scripts! For some excellent information on Git workflows, see [Atlassian's Git Tutorials](https://www.atlassian.com/git/workflows#!workflow-overview) or Vincent Driessen's articles on Git at [nvie.com](http://nvie.com/).

The program is designed to be used in conjunction with Git, not instead of it. The commands are accessible using the `gitflow <command>` syntax. It doesn't take over the project (this is the least opinionated part of GitFlow) and you should be able to use the program whether you already have an active Git repo or are just creating one. Just use `git init` to make sure your project is set up for GitFlow.

## Installation

Download and compile the program using `make`. At the terminal:

    make install

The program will be installed to your `/usr/local/gitflow` folder, with a symlink in `/usr/local/bin` so that you can call GitFlow from anywhere you can call Git!


Node.js users will soon be able to install the scripts using NPM:

    npm install -g gitflow

## Usage

GitFlow is an opinionated Git workflow tool with some serious ideas about how to organize your code. It is based on the ideas presented in Vincent Driessen's articles on Git workflows [here](http://nvie.com/). 

There are four basic commands in GitFlow:

- init
- feature
- patch
- release

As well as one more command specific to GitHub:

- gh-pages

### Init

The `init` command sets up your project to use GitFlow. It creates a 'development' branch (also known as an integration branch) in your project if it doesn't already exist and sets some more options for the development workflow specified in the following commands.

#### Usage

    gitflow init [-c | --commit] [-g | --gh-pages] <remote_url>

- -c: make a first commit (even if it's empty)
- -g: set up gh-pages
- remote_url: the URL to your project (on GitHub/wherever)

### Feature

Every update to your project comes from 'feature' branches. Use the `feature` command to create a new branch off of 'development'. This is where all of your development will go.

#### Usage

    gitflow feature <branch_name> [-d | --delete] [-m | --merge] [<destination_branch>]

- branch_name: the name of the feature branch you wish to create
- -d: delete the branch
- -m: merge the branch into 'development'
- destination_branch: optionally specify a destination branch to merge into

### Release

Once you have accumulated features and are ready to release a new version, use the `release` command to create a new release branch off of 'development', make any last minute changes, and then merge the release branch into 'master' _and_ 'development'. 

#### Usage

    gitflow release <semver_tag> [-d | --delete] [-m | --merge]

- semver_tag: semantic versioning tag (e.g. 'v0.10.0-alpha')
- -d: delete the branch
- -m: merge branch into 'master' and 'development'

### Patch

If, after a release branch has been published, a bug is spotted, the `patch` command is useful for creating a branch that is used for fixing the issue. It creates a new 'issue' branch off of 'master' that will merge into the 'master' _and_ 'development' branches.

#### Usage

    gitflow patch <issue_number> [-d | --delete] [-m | --merge]

- issue_number: the number of the issue addressed by this fix (**NOTE:** Do not use the hash symbol when writing this number in he command)
- -d: delete the branch
- -m: merge branch into 'master' and 'development'

### Gh-Pages

The `gh-pages` command is specific to the documentation branch on GitHub. It creates an empty orphan branch that holds all of your documentation and an index.html file which is viewable at: `yourusername.github.com/yourproject`

#### Usage

	gitflow gh-pages [-c | --commit]

- -c: make a first commit (even if it's empty)


## Contributing

The project is under active development. Please contribute! I am not, in any sense, a good C or BASH developer. It would be useful to get some feedback and review on those parts of the program.


## Un-Installation

If for any reason you want to uninstall GitFlow, run the `make uninstall` command.