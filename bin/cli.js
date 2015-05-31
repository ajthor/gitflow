#!/usr/bin/env node

'use strict';

var _ = require('underscore');

var gitflow = require('../lib/gitflow.js');

// Command-Line Tool
// =================
// This is a typical Node.js CLI program.

// Parse Arguments
// ---------------
// Parses all arguments passed to the program.

var parseArgv = function (argv) {
	var i, arg;
	var obj = {
		commands: [],
		flags: [],
		options: []
	};

	for (i = argv.length; i--; ) {
		arg = argv[i];

		if (arg.slice(2) === '--') { // Option
			obj[ arg.slice(2) ] = true;
		}
		else if (arg[0] === '-') { // Flag
			obj.flags.push(arg);

			if (arg === '-h') {
				process.exit(1);
			}
		}
		else { // Command
			Array.prototype.push.apply(obj.commands, [arg]);
		}
	}

	if (_.isEmpty(obj.commands)) {
		process.exit(9);
	}

	return obj;
};

// Handle Error Codes
// ------------------

process.on('exit', function(code) {
	switch (code) {
		case 9:
			console.error('INVALID ARGUMENT: Must provide a valid command to \'gitflow\'\n');
			// Default error code to exit program. Displays help text.
			console.error('usage:  gitflow <command> [options]');
			console.error('Valid Commands: \n  - init\n  - feature\n  - issue\n  - release');
			break;
		case 64:
			console.error('ERROR: Could not authenticate user.');
		case 1:
			console.error('The program quit unexpectedly.');
			break;
	}
});

// CLI
// ---
// The command-line tool begins here.

var args = process.argv.slice(2);
var obj = parseArgv(args);

gitflow.run(obj);
