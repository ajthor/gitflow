#include <stdio.h>

const char desc[] = 
	"`gitflow feature` adds a new feature branch to the current repo.";
const char usage[] = 
	"gitflow feature\n"
	"        feature [--someFlag]";

static void show_usage() {
	printf("\n %s\n", desc);
	printf("%s\n", usage);
}

int main(int argc, char const *argv[])
{
	printf("Running!");
	return 0;
}