typedef struct {
	unsigned major;
	unsigned minor;
	unsigned patch;

	char * note;

	char * meta;

	char tag[64];

} semver;

void generate_semver(char *, semver *);

void init_semver(semver *);

void bump_semver(semver *, int);