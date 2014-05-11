static const char * builtin_commands[] = {
};

static const char * shell_commands[] = {
	"feature",
	"patch",
	"gh-pages",
	"init"
};

extern int exec_gitflow_command(const char *, int, const char **);
extern int exec_shell_command(const char *, int, const char **);


