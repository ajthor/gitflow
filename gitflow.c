#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "builtin/gitflow-branch.h"
#include "builtin/gitflow-feature.h"
#include "builtin/gitflow-gh-pages.h"
#include "builtin/gitflow-init.h"
#include "builtin/gitflow-status.h"

#include "semver.h"
#include "run_command.h"

#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

const char usage[] = 
	"gitflow <command> [<args>]\n";

const char help[] =
	"GitFlow is a command-line Git workflow helper that uses the\n" 
	"core functionality of Git to provide wrappers for basic \n"
	"development workflow tasks.\n";


// Handle_Options Function
// -----------------------
// Looks at all options passed to the program and deals with all 
// options relevant to this routine. Some of the flags or options may 
// apply to the command specified, in which case, pass those along to 
// the next command.
static const char ** handle_options(const char * cmd, int argc, const char * argv[]) {
	int i;
	const char ** new_argv;
	new_argv = malloc(sizeof(new_argv) * (argc + 4));

	// Remove the first two commands from the array. They correspond 
	// to the script name and the command. We have already extracted 
	// that, so no need to include it here.
	for(i = 2; i < argc; i++) {
		new_argv[i - 2] = argv[i];
	}

	return new_argv;
}

// Command Structure
// -----------------
typedef struct {
	const char cmd[16];
	const char desc[256];
}command;

// Commands Array
// --------------
static command commands[] = {
	{ "feature",  "Add a new feature branch to the workflow." },
	{ "gh-pages", "Initialize the gh-pages branch." },
	{ "init",     "Initialize the GitFlow workspace." },
	{ "patch",    "Add a new patch branch to the workflow." },
	{ "release",  "Create a new release branch." },
	{ "help",     "Display GitFlow help." }
};

// Alias Structure
// ---------------
typedef struct {
	const char cmd[16];
	const char alias[16];
}alias;

// Alias Array
// -----------
static alias aliases[] = {
	{ "feature",  "f" },
	{ "feature",  "topic" },
	{ "gh-pages", "gp" },
	{ "gh-pages", "ghp" },
	{ "gh-pages", "pages" },
	{ "gh-pages", "docs" },
	{ "gh-pages", "documentation" },
	{ "init",     "i" },
	{ "init",     "initialize" },
	{ "patch",    "p" },
	{ "patch",    "issue" },
	{ "patch",    "hotfix" },
	{ "release",  "r" },
	{ "help",     "h" }
};

// Extract_Commands Function
// -------------------------
// Searches through the list of arguments, starting at the beginning, 
// for one that matches a command listed in the commands array. If no 
// matches are found, search through aliases to find commands that 
// are possible mistyped or shortened intentionally.
static const char * extract_command(int argc, const char * argv[]) {
	int i = 0;
	int j = 0;
	int k = 0;
	int len = argc;

	alias * a;
	command * s;

	while(i < len) {

		if(argv[i][0] == '-') {
			// This is a flag or an option. No need to search it 
			// for a command. Just check if the user needs help.
			if(!strcmp(argv[i], "-h") || !strcmp(argv[i], "--help")) {
				return "help";
			}
		}
		else {
			// Search in the commands array to see if the command 
			// matches one of the pre-defined commands.
			for(j = ARRAY_SIZE(commands) - 1; j >= 0; j--) {
				s = &commands[j];

				if( !strcmp(argv[i], s->cmd) ) {
					return s->cmd;
				}
			}

			// No command found. Check aliases.
			for(j = ARRAY_SIZE(aliases) - 1; j >= 0; j--) {
				a = &aliases[j];

				if( !strcmp(argv[i], a->alias) ) {
					return a->cmd;
				} 
			}

			// If the command doesn't exist in either the alias 
			// array or the commands array, compare the command 
			// letter by letter to see if it is the beginning of a 
			// command that exists. Matches down to three letters.
			for(j = ARRAY_SIZE(commands) - 1; j >= 0; j--) {
				s = &commands[j];

				for(k = strlen(argv[i]); k >= 2; k--) {

					if( !strncmp(argv[i], s->cmd, k) ) {
						return s->cmd;
					}
				}
			}

		}

		i++;
	}

	return "help";
}

static int is_builtin(const char * cmd) {
	int i;
	int len;
	const char ** s;

	for(i = 0, len = ARRAY_SIZE(builtin_commands); i < len; i++) {
		s = &builtin_commands[i];
		if(!strcmp(cmd, *s))
			return 1;
	}

	return 0;
}

// Run_Command Function
// --------------------
int run_command(const char * cmd, const char * argv[]) {

	if(is_builtin(cmd)) {
		return exec_gitflow_command(cmd, argv);
	}
	else {
		return exec_shell_command(cmd, argv);
	}

	return 1;
}

// Show_Usage Function
// -------------------
// Displays help and usage information for GitFlow.
static void show_usage() {
	int i;
	int len;
	command * s;
	printf("\n %s\n", help);
	printf("%s\n", usage);
	printf("Commands:\n");
	for(i = 0, len = ARRAY_SIZE(commands); i < len; i++) {
		s = &commands[i];
		printf(" - %s: %s\n", s->cmd, s->desc);
	}
}

// Main Function
// -------------
// Entry point into the application. Handles the CLI input. Searches 
// for the command passed to the function and passes it and any 
// arguments which may pertain to it to a new child process.
int main(int argc, const char * argv[])
{
	const char * cmd;
	const char ** new_argv;
	
	if(argc < 1) {
		return 1;
	}

	cmd = extract_command(argc, argv);

	new_argv = handle_options(cmd, argc, argv);

	if(!strcmp(cmd, "help")) {
		show_usage();
	}
	else {
		return run_command(cmd, new_argv);
	}

	free(new_argv);

	return 0;
}


