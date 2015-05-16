#!/usr/bin/env node

'use strict';

var _ = require('underscore');

var gitflow = require('./gitflow.js');

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

			if (arg === '-h') {
				usage();
				process.exit(1);
			}
		}
		else { // Command
			obj.command = arg;
		}
	}

	if (!obj.command) {
		usage();
		process.exit(1);
	}

	return obj;
};

// CLI
// ---
// The command-line tool begins here.

var args = process.argv.slice(2);
var obj = parseArgv(args);

var utility = new gitflow(obj);

utility.run(obj.command);


