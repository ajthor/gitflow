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

// Authenticate on GitHub
// ----------------------
// This function authenticates the user on GitHub using token/Oauth2
// authentication. If there is no token stored in the config file, GitFlow
// will ask for credentials to log in and create a new token.
var authenticate = function (config, options, callback) {
	console.log('Authenticating...');

	if (_.isUndefined(config.token)) {
		prompt.start();

		prompt.get({
		  properties: {
		    username: {
		      pattern: /^[a-zA-Z\s\-]+$/,
		      message: 'Name must be only letters, spaces, or dashes',
		      required: true
		    },
		    password: {
		      hidden: true,
					required: true
		    }
		  }
		}, function (err, result) {
			if (err) {
				console.error(err);
				return callback(err);
			}

			// Add the username to the configuration file to use in later GitHub
			// api calls.
			config.username = result.username;

			github.authenticate({
				type: 'basic',
				username: result.username,
				password: result.password
			});

			// Create an authorization token. Can be managed in GitHub settings.
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
					console.error(err);
					process.exit(64); // Could not authenticate.
				}

		    if (res.token) {

					// If a token was returned, add the token to the configuration object.
					config.token = res.token;

		    }

				return callback();
			});
		});

	}
	else {

		// If a token is already present in the configuration file, use it
		// to authenticate.
		github.authenticate({
			type: 'oauth',
			token: config.token
		});

		return callback();
	}

};

// Load Config
// -----------
// Loads the config file from the home folder. The default location for the
// config file is in the home directory and is called '.gitflow.json'.
var loadConfig = function () {
	try {
		var config = require(path.join(home, '.gitflow.json'));

	} catch (e) {
		console.error('ERROR: ' + e.message);

	} finally {
		// If no config file is found, create a default config file.
		return (config || {
			// Config defaults.
			home: home
		});
	}
};

// Save Config
// -----------
// Save the config JSON data, including all changes back to the config file.
var saveConfig = function (config, callback) {
	try {
		fs.writeFile(path.join(config.home, '.gitflow.json'), JSON.stringify(config, null, 2), function (err) {
			if (err) {
				console.log(err.message);
			}

			return callback();
		});
	} catch (e) {
		console.error('ERROR: ' + e.message);
	}
};

// Run
// ---
// The main entry-point into the program. In order, the run function loads the
// config file, authenticates the user, calls a file from the lib folder, and
// saves the configuration file back to the home directory.
// __GitFlow calls the file based on the file name. Adding a new command
// requires adding a new file to the lib folder.__
exports.run = function (options) {

		var config = loadConfig();

		async.series([

			// Authenticate the user.
			function (done) {
				authenticate(config, options, done);
			},

			// Run the command.
			function (done) {
				try {

					var cmd = require(path.join('../lib/', options.commands.pop()));
					cmd(github, config, options);

				} catch (e) {
					console.error(e.message);
					process.exit(9); // Command is not valid/does not exist.
					
				} finally {
					return done(null);
				}
			},

			// Save config file.
			function (done) {
				saveConfig(config, done);
			}

		], function (err) {
			if (err) {
				console.error(err.message);
			}

		});
};
