static const char * builtin_commands[] = {
};

static const char * shell_commands[] = {
	"feature",
	"patch",
	"gh-pages",
	"init"
};

extern int exec_gitflow_command(const char * cmd, int argc, const char * argv[]);
extern int exec_shell_command(const char * cmd, int argc, const char * argv[]);


