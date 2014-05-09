#include "semver.h"

#include <stdio.h>
#include <string.h>

// Semver Functions
// ================
// These functions work with the `semver` struct defined in the 
// `semver.h` file. The struct has some variables related to the 
// semantic version string which it will output in the `tag` 
// variable.

// Generate_Semver Function
// ------------------------
// Probably the most useful function in the file, it accepts a string 
// and a semver struct and generates a semver tag from the struct and 
// copies the value to the string.
void generate_semver(char * tag, semver * s) {
	sprintf( tag, "v%d.%d.%d",
		s->major, s->minor, s->patch);	

// Don't include the note or meta information if it doesn't exist. 
// - Notes are added before meta with a hyphen '-'. 
// - Meta or build information is added last with a plus sign '+'.
	if(strlen(s->note) > 1) {
		strcat(tag, "-");
		strcat(tag, s->note);
	}
	if(strlen(s->meta) > 1) {
		strcat(tag, "+");
		strcat(tag, s->meta);
	}
}

// Init_Semver Function
// --------------------
// Initializes a semver struct to its default values. <<__Developer's 
// Note:__ I tried to avoid using `malloc` as much as possible here, 
// because I don't want people to have to de-allocate the 
// semver struct.>> All values default to 0.
void init_semver(semver * s) {
	s->major = 0;
	s->minor = 0;
	s->patch = 0;

	s->note = "\0";
	s->meta = "\0";

	generate_semver(s->tag, s);
}

// Bump_Semver Function
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

	generate_semver(s->tag, s);
}


