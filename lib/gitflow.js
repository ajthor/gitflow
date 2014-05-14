#!/usr/bin/env node

'use strict';

// Require underscore.
var _ = require('underscore');

var async = require('async');
var util = require('util');
var path = require('path');
var spawn = require('child_process').spawn;
var sh;

// GitFlow Node.js Command-Line Tool
// =================================
// This is the Node.js implementation of GitFlow for those who don't 
// want to bother with C programs or Makefiles. If you have Node 
// installed already, you can install this CLI from NPM globally in 
// order to use it from the terminal.

var usageMsg = 'usage:  gitflow <command> [options]';

// A pre-defined list of commands which are allowed in GitFlow.
var commandList = [
	'feature',
	'init',
	'release',
	'patch',
	'gh-pages'
];

var usage = function() {
	console.log(usageMsg);
}

// CLI
// ---
// The command-line functionality is defined here. First, it takes 
// the argument immediately following the script name and checks to 
// see if it is a valid command. If so, it invokes the corresponding 
// script and passes the remaining arguments to it.
var i;
var command = process.argv[2];

var script;
var scriptPath;

if(_.contains(commandList, command)) {
	
	script = command + '.sh';
	scriptPath = path.join('../', 'scripts/', script);
	// Call Bash Script
	// ----------------
	// Call bash script residing in the 'scripts/' folder 
	// corresponding to the command given.
	command = Array.prototype.concat(
			[scriptPath], 
			process.argv.slice(3)
		);

	async.series([
		function(callback) {

			sh = spawn('sh', command, {
				cwd: process.cwd()
			});

			sh.stdout.on('data', function (data) {    // register one or more handlers
				process.stdout.write(data);
			});

			sh.stderr.on('data', function (data) {
				console.log('Error: ', data);
			});

			sh.on('exit', function (code) {
				process.exit(code);
			});

			callback(null);

		}
	], 
	function(err, results) {
		if(err) {
			console.log("Error: ", err);
		}
	});

}
// If something went wrong, show the usage information and exit with 
// an error signal.
else {
	usage();
	process.exit(1);
}


