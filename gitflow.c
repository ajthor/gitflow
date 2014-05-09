#include "include/git2.h"

#include "semver.h"
#include "run_command.h"

#include "gitflow-branch.h"
#include "gitflow-feature.h"
#include "gitflow-gh-pages.h"
#include "gitflow-init.h"
#include "gitflow-status.h"

#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

const char usage[] = 
	"gitflow \n"
	"        <command> [<args>]\n";

const char help[] =
	"GitFlow is a command-line Git workflow helper that uses the\n" 
	"core functionality of Git to provide wrappers for basic \n"
	"development workflow tasks.\n";

// Check_Error Function
// --------------------
static void check_error(int code, const char * action) {
	const git_error * error = giterr_last();
	if(!code)
		return;

	printf("Error [ %d ](%s): %s", code, action,
		(error && error->message) ? error->message : "An unexpected error occurred.");

	exit(1);
}

// Handle_Options Function
// -----------------------
// Looks at all options passed to the program and deals with all 
// options relevant to this routine. Some of the flags or options may 
// apply to the command specified, in which case, pass those along to 
// the next command.
static int handle_options(int argc, char const **argv[], int *envchanged) {
	return 1;
}

// Command Structure
// -----------------
typedef struct {
	const char cmd[10];
	const char desc[256];
}command;

// Commands Array
// --------------
static command commands[] = {
	{ "feature",  "Add a new feature branch to the workflow." },
	{ "gh-pages", "Initialize the gh-pages branch." },
	{ "init",     "Initialize the GitFlow workspace." },
	{ "patch",    "Add a new patch branch to the workflow." },
	{ "help",     "Display GitFlow help." }
};

// Extract_Commands Function
// -------------------------
// Searches through the list of arguments, starting at the beginning, 
// for one that matches a command listed in the commands array. If no 
// matches are found, search through aliases to find commands that 
// are possible mistyped or shortened intentionally.
static char const * extract_command(int argc, char const *argv[]) {
	int i = 0;
	int j = 0;
	int len = argc;

	command * s;

	while(i < len) {

		if(argv[i][0] == '-') {
			// This is a flag or an option. No need to search it 
			// for a command.
		}
		else {
			// Not a flag or an option. Cycle through all commands 
			// and find which one this is.
			for(j = ARRAY_SIZE(commands) - 1; j >= 0; j--) {
				s = &commands[j];

				// printf("%s = %s?\n", argv[i], s->cmd);

				if( !strcmp(argv[i], s->cmd) ) {
					// printf("YES\n");
					return argv[i];
				}
			}

			// No command found. Check aliases.
			// for(j = ARRAY_SIZE(aliases); j >= 0; j--) {

			// }

		}

		i++;
	}

	return "help";
}

static int is_builtin(char const * cmd) {
	int i;
	int len;
	char const ** s;
	// Evaluate if the command is a script or a git command.
	for(i = 0, len = ARRAY_SIZE(builtin_commands); i < len; i++) {
		s = &builtin_commands[i];
		if(!strcmp(cmd, *s))
			return 1;
	}

	return 0;
}

// Run_Command Function
// --------------------
int run_command(char const * cmd, int argc, char const * argv[]) {

	if(is_builtin(cmd)) {
		// GitFlow command.
		printf("GitFlow, huzzah!\n");
		// return exec_gitflow_command(cmd, argc, argv);
	}
	else {
		// Shell command.
		printf("Shell!\n");
		// return exec_shell_command(cmd, argc, argv);
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
int main(int argc, char const * argv[])
{
	char const * cmd;
	// char const * new_argv[];

	if(argc < 2) {
		return 1;
	}

	cmd = extract_command(argc, argv);
	
	printf("Command: %s\n", cmd);

	if(!strcmp(cmd, "help")) {
		show_usage();
	}
	else {
		// User doesn't need help. Run a command!
		run_command(cmd, argc, argv);
	}

	return 0;
}

