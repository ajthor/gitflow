#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

#include "run_command.h"

// Execution Commands
// ------------------
// These functions run commands in different contexts based on 
// whether the command is a shell command or an internal 
// GitFlow command.

static const char ** prepare_command(const char * cmd, const char ** argv) {
	int argc;
	int new_argc = 0;
	const char ** new_argv;

	for(argc = 0; argv[argc]; argc++)
		;

	new_argv = malloc(sizeof(new_argv) * (argc + 4));

	if(argc < 1)
		exit(1);

	sprintf( new_argv[new_argc++] , "./gitflow-%s.sh", cmd);

	// new_argv[new_argc++] = "sh";

	// new_argv[new_argc++] = "-c";

	for( argc = 0; argv[argc]; argc++) {
		new_argv[new_argc++] = argv[argc];
		printf("%s  ", argv[argc]);
	}

	new_argv[new_argc] = NULL;


	return new_argv;
}

static int exec_command(const char * cmd, char * const argv[]) {

	// pid_t my_pid, parent_pid, child_pid;
	// my_pid = getpid();
	// parent_pid = getppid();

	// shell_cmd = prepare_command(cmd);

	// printf("Running shell command: %s\n", cmd);

	// switch( child_pid = fork() ) {
	// 	case -1:
	// 		printf("Fork failed!\n");
	// 		exit(1);

	// 	case 0: // Child
	// 		printf("I am the child.\n");
	// 		execvp(shell_cmd, new_argv);

	// 		printf("I should never reach this line.\n");
	// 		exit(1);

	// 	default: // Parent
	// 		wait(&status);
	// 		break;

	// }

	return 1;
}

int exec_gitflow_command(const char * cmd, int argc, const char ** argv) {
	// Call child process using info from struct.
	return 0;
}

int exec_shell_command(const char * cmd, int argc, const char ** argv) {
	const char ** new_argv = prepare_command(cmd, argv);
	exec_command(new_argv[0], (char **)new_argv);
	free(new_argv);
	return 1;
}


