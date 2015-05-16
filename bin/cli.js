#!/usr/bin/env node

'use strict';

// Command-Line Tool
// =================
// This is a typical Node.js CLI program.

var usageMsg = 'usage:  gitflow <command> [options]';

var usage = function () {
	console.log(usageMsg);
};

// Parse Arguments
// ---------------
// Parses all arguments passed to the program.

var parseArgv = function (argv) {
	var i, arg;
	var obj = {
		command: '',
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
		}
		else { // Command
			obj.command = arg;
		}
	}

	return obj;
};

// CLI
// ---
// The command-line tool begins here.

console.log('GitFlow CLI');

var args = process.argv.slice(2);
var obj = parseArgv(args);




