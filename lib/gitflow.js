'use strict';

var fs = require('fs');
var path = require('path');

var _ = require('underscore');
var async = require('async');

var GitHubAPI = require('github');
var prompt = require('prompt');

var home = path.resolve(process.env[(process.platform === 'win32') ? 'USERPROFILE' : 'HOME']);

// GitHub API object.
var github = new GitHubAPI({
	version: '3.0.0',
	protocol: 'https'
});

var authenticate = function (config, obj, cb) {
	console.log('Authenticating...');

	if (_.isUndefined(config.token)) {
		prompt.start();

		prompt.get({
		  properties: {
		    username: {
		      pattern: /^[a-zA-Z\s\-]+$/,
		      message: 'Name must be only letters, spaces, or dashes.',
		      required: true
		    },
		    password: {
		      hidden: true,
					required: true
		    }
		  }
		}, function (err, result) {
			if (err) {
				console.log(err);
				process.exit(1);
			}

			config.username = username;

			github.authenticate({
				type: 'basic',
				username: result.username,
				password: result.password
			});

			github.authorization.create({
			    scopes: [
						"public_repo",
						"repo",
						"repo:status",
						"gist"
					],
			    note: "GitFlow CLI access.",
			    note_url: "https://github.com/ajthor/gitflow",
			    headers: {
			        "X-GitHub-OTP": "two-factor-code"
			    }
			}, function(err, res) {
				if (err) {
					console.log(err);
					process.exit(1);
				}

		    if (res.token) {
					config.token = res.token;
		    }

				cb();
			});
		});

	}
	else {
		github.authenticate({
			type: 'oauth',
			token: config.token
		});

		cb();
	}

};

var loadConfig = function () {
	try {
		var config = _.defaults(require(path.join(home, '.gitflow.json')), {
			// Config defaults.
			home: home
		});

	} catch (e) {
		// If no config file is found, create a default config file.
		console.log('ERROR: ' + e.message);
		console.log('WARNING: No config file found.');

	} finally {
		return (config || {});
	}
};

var saveConfig = function (config, cb) {
	try {
		fs.writeFile(path.join(config.home, '.gitflow.json'), JSON.stringify(config, null, 2), function (err) {
			if (err) {
				console.log(err.message);
			}

			cb();
		});
	} catch (e) {
		console.log('ERROR: ' + e.message);
		process.exit(1);
	}
};

exports.run = function (obj) {
		// Load config file.
		var config = loadConfig();

		async.series([
			// Authenticate the user.
			function (cb) {
				authenticate(config, obj, cb);
			},

			// Run the command.
			function (cb) {
				// Load command file.
				try {

					var cmd = require('../lib/' + obj.commands[0]);
					cmd[obj.commands[0]](github, config, obj);

				} catch (e) {
					console.log(e.message);

					// Command is not valid.
					process.exit(9);
				}

				cb();
			},

			// Save config file.
			function (cb) {
				saveConfig(config, cb);
			}

		], function (err) {
			if (err) {
				console.log(err.message);
				process.exit(1);
			}

		});
};
