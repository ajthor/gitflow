static char const * builtin_commands[] = {
};

static char const * shell_commands[] = {
	"feature",
	"patch",
	"gh-pages",
	"init"
};

extern int exec_gitflow_command(char const * cmd, int argc, char const * argv[]);
extern int exec_shell_command(char const * cmd, int argc, char const * argv[]);


