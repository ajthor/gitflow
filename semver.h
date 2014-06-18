typedef struct {
	unsigned major;
	unsigned minor;
	unsigned patch;

	char note[32];

	char meta[126];

	char tag[64];

} semver;

semver * create_semver();

void bump_semver(semver *, int);