'use strict';

var fs = require('fs');
var path = require('path');

var _ = require('underscore');
var async = require('async');

var prompt = require('prompt');

var nodegit = require('nodegit');

var createBranch = require('./utils/createBranch');

// Initialize Repository
// ---------------------
// Checks on GitHub to see if the repository exists already. If it doesn't,
// it creates a repository on GitHub using default options.
var initializeRepository = function (obj, callback) {

	async.waterfall([

		// Check for repo on GitHub.
		function (done) {
			obj.api.repos.get({
				user: obj.config.username,
				repo: obj.options.repo
			}, function (err, result) {
				if (err) {
					console.error('Repository not found.');
					return done(null, false);
				}

				return done(null, true);
			});
		},

		// Initialize repo if it doesn't already exist.
		function (exists, done) {
			if (exists) {
				console.log('Repository is already initialized.');
				return done(null);
			}

			obj.api.repos.create({
				name: result.repo,
				has_issues: true,
				has_wiki: true,
				auto_init: true
			}, function (err, result) {
				if (err) {
					console.error('Could not initialize repository.');
				}

				return done(null);
			});

		}

	], function (err) {
		if (err) {
			console.error(err.message);
		}

		callback();
	});
};

// Initialize Repository
// ---------------------
// Initializing a repository can be tricky. Here, I have outlined several steps
// which I think goes into repository creation and validation. Any of this
// could be changed at a later time if a better process is found.
//
// 1. Check if the repo exists on GitHub.
//   - If the repo does not exist, create it.
// 2. Create a gh-pages branch.
// 3. Create a development branch.
// 4. Clone the repo to the current directory.
module.exports = function init (api, config, options) {
	console.log('Initializing...');

	prompt.start();

	prompt.get({
		properties: {
			repo: {
	      pattern: /^[a-zA-Z\s\-]+$/,
	      message: 'Name must be only letters, spaces, or dashes',
				required: true
			}
		}
	}, function (err, result) {

		options.repo = result.repo;

		async.series([

			// Initialize repository.
			function (done) {

				initializeRepository({
					api: api,
					config: config,
					options: options
				}, done);

			},

			// Create development branch.
			function (done) {

				createBranch({
					api: api,
					config: config,
					options: options,
					branch: 'development',
					base: 'master'
				}, done);

			},

			// Create gh-pages branch.
			// function (done) {
			//
			// 	createBranch({
			// 		api: api,
			// 		config: config,
			// 		options: options,
			// 		branch: 'gh-pages',
			// 		base: '/dev/null',
			// 		sha: '4b825dc642cb6eb9a060e54bf8d69288fbee4904'
			// 	}, done);
			//
			// }

			// Clone repository.
			function (done) {
				return done(null);
			}

		], function (err) {
			if (err) {
				console.error('ERROR: Could not initialize repository.');
			}
		});

	});

};
