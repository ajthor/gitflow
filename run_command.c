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

int exec_gitflow_command(char const * cmd, int argc, char const * argv[]) {
	// Call child process using info from struct.
	return 0;
}

int exec_shell_command(char const * cmd, int argc, char const * argv[]) {
	// Call child process using info from struct.
	pid_t my_pid, parent_pid, child_pid;
	char shell_cmd[1024];

	int i;
	int status;
	char * new_argv[ argc ];

	if(new_argv == NULL) {
		// Something went wrong.
	}

	my_pid = getpid();
	parent_pid = getppid();

	printf("Running shell command: %s\n", cmd);

	sprintf(shell_cmd, "./gitflow-%s.sh", cmd);
	printf("%s\n", shell_cmd);

	// for(i = 0; i < argc; i++) {
	// 	strcpy(new_argv[i], argv[i]);
	// }

	switch( child_pid = fork() ) {
		case -1:
			printf("Fork failed!\n");
			exit(1);

		case 0: // Child
			printf("I am the child.\n");
			execvp(shell_cmd, new_argv);

			printf("I should never reach this line.\n");
			exit(1);

		default: // Parent
			wait(&status);
			break;

	}

	return 0;
}


