#include <run_command.h>

// Execution Commands
// ------------------
// These functions run commands in different contexts based on 
// whether the command is a shell command or an internal 
// GirFlow command.

int exec_gitflow_command(struct child_process *cp) {
	// Call child process using info from struct.
}

int exec_shell_command(struct child_process *cp) {
	// Call child process using info from struct.
}


