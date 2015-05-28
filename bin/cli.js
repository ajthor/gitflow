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
			obj.commands.push(arg);
		}
	}

	if (_.isEmpty(obj.commands)) {
		process.exit(9);
	}

	return obj;
};

process.on('exit', function(code) {
	switch (code) {
		case 9:
			console.log('INVALID ARGUMENT: Must provide a valid command to \'gitflow\'');
			break;
		case 1:
			console.log('usage:  gitflow <command> [options]');
			console.log('Valid Commands: \n  - init\n  - feature\n  - issue\n  - release');
			break;
	}
});

// CLI
// ---
// The command-line tool begins here.

var args = process.argv.slice(2);
var obj = parseArgv(args);

var utility = new gitflow(obj);

utility.run(obj.commands);
