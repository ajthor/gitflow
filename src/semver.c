#include "semver.h"

#include <stdio.h>
#include <string.h>

// Semver Functions
// ================
// These functions work with the `semver` struct defined in the 
// `semver.h` file. The struct has some variables related to the 
// semantic version string which it will output in the `tag` 
// variable.

// generate_semver_string Function
// -------------------------------
// Probably the most useful function in the file, it accepts a semver 
// struct and generates a semver tag from the struct and copies the 
// value to the string.
static void generate_semver_string(semver * s) {
	sprintf( s->tag, "v%d.%d.%d",
		s->major, s->minor, s->patch);	

// Don't include the note or meta information if it doesn't exist. 
// - Notes are added before meta with a hyphen '-'. 
// - Meta or build information is added last with a plus sign '+'.
	if(strlen(s->note) > 1) {
		strcat(s->tag, "-");
		strcat(s->tag, s->note);
	}
	if(strlen(s->meta) > 1) {
		strcat(s->tag, "+");
		strcat(s->tag, s->meta);
	}
}

// create_semver Function
// ----------------------
// Returns a new semver struct with default values. 
// *All values default to 0.*
semver * create_semver() {
	semver * s = malloc(sizeof(semver));

	s->major = 0;
	s->minor = 0;
	s->patch = 0;

	s->note = "\0";
	s->meta = "\0";

	generate_semver_string(s);
}

void destroy_semver(semver * s) {
	free(s);
}

// bump_semver Function
// --------------------
// Function 'bumps' the semver by incrementing the major, minor, or 
// patch number by one. Follows semantic versioning rules. See 
// (http://semver.org)[http://semver.org] for more information. 
// Accepts an integer value in the range (1-3) to determine which 
// number to increment.
// 1: bump major version
// 2: bump minor version (default)
// 3: bump patch
void bump_semver(semver * s, int type) {
	switch(type) {
		case 1:
			// Bump major release.
			s->major++;
			s->minor = 0;
			s->patch = 0;
			break;
		case 3:
			// Bump patch.
			s->patch++;
			break;
		default:
		case 2:
			// Bump minor release.
			s->minor++;
			s->patch = 0;
			break;
	}

	generate_semver_string(s);
}


