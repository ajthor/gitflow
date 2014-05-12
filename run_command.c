#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/wait.h>

#include "run_command.h"

#define SHELL_PATH "/bin/sh"

#if defined(_WIN32) || defined(WIN32) && !defined(__CYGWIN__)
#include <windows.h>
#define WINDOWS
#endif

// Execution Commands
// ------------------
// These functions run commands in different contexts based on 
// whether the command is a shell command or an internal 
// GitFlow command.

static char * prepare_shell_command(const char * cmd) {
	char * shell_cmd = malloc(sizeof(cmd) + 5);
	sprintf(shell_cmd, "./%s.sh", cmd);

	return shell_cmd;
}

static const char ** prepare_command(const char * cmd, const char ** argv) {
	int argc;
	int new_argc = 0;

	const char ** new_argv;

	for(argc = 0; argv[argc]; argc++)
		;

	new_argv = malloc(sizeof(new_argv) * (argc + 4));

	if(argc < 1)
		exit(1);


#ifndef WINDOWS
	new_argv[new_argc++] = SHELL_PATH;
#else
	new_argv[new_argc++] = "sh";
#endif
	// new_argv[new_argc++] = "-c";

	new_argv[new_argc++] = cmd;

	for(argc = 0; argv[argc]; argc++) {
		new_argv[new_argc++] = argv[argc];
	}

	new_argv[new_argc] = NULL;

	return new_argv;
}

static int exec_command(const char * cmd, char * const argv[]) {

	pid_t my_pid, parent_pid, child_pid;
	int child_status;

	int i, argc;
	for(argc = 0; argv[argc]; argc++) 
		;

	for(i = 0; i < argc; i++) {
		printf("%s\n", argv[i]);
	}

	my_pid = getpid();
	parent_pid = getppid();

	switch( child_pid = fork() ) {
		case -1:
			printf("Fork failed!\n");
			exit(1);

		case 0: // Child
			execvp(argv[0], argv);

			printf("I should never reach this line.\n");
			exit(1);

		default: // Parent
			wait(&child_status);
			break;

	}

	return 1;
}

int exec_gitflow_command(const char * cmd, const char ** argv) {
	// Call child process.
	return 0;
}

int exec_shell_command(const char * cmd, const char ** argv) {
	char * shell_cmd = prepare_shell_command(cmd);
	const char ** new_argv = prepare_command(shell_cmd, argv);

	exec_command(new_argv[0], (char **)new_argv);

	free(shell_cmd);
	free(new_argv);
	return 1;
}


