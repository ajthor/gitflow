#ifndef RUN_COMMAND_H
#define RUN_COMMAND_H

static char const * builtin_commands[] = {
	"feature",
	"patch"
};

static char const * shell_commands[] = {
	"gh-pages",
	"init"
};

int exec_gitflow_command(char const * cmd, int argc, char const * argv[]);
int exec_shell_command(char const * cmd, int argc, char const * argv[]);

#endif /* RUN_COMMAND_H */