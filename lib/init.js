'use strict';

var fs = require('fs');
var path = require('path');

var _ = require('underscore');
var async = require('async');

var prompt = require('prompt');

var initRepo = function (api, config, options, callback) {
	async.waterfall([
		// Check for repo on GitHub.
		function (done) {
			api.repos.get({
				user: config.username,
				repo: options.repo
			}, function (err, result) {
				if (err) {
					console.log('Repository not found.');
				}

				done(null, !_.isUndefined(result));
			});
		},

		// Initialize repo if it doesn't already exist.
		function (exists, done) {
			if (!exists) {
				api.repos.create({
					name: result.repo,
					has_issues: true,
					auto_init: true
				}, function (err, result) {
					if (err) {
						console.error('Could not initialize repository.');
					}

					done(null);
				});
			}
			else {
				console.log('Repository is already initialized.');
				done(null);
			}
		},

		// Clone repo to folder.
		function (done) {
			done(null);
		}

	], function (err) {
		if (err) {
			console.error(err.message);
		}
	});
};

var createDevelopmentBranch = function (api, config, options, callback) {

};

var createGHPagesBranch = function (api, config, options, callback) {

};

var synchronize = function (api, config, options, callback) {

};

exports.init = function (api, config, options) {
	console.log('Initializing...');

	prompt.start();

	prompt.get({
		properties: {
			repo: {
	      pattern: /^[a-zA-Z\s\-]+$/,
	      message: 'Name must be only letters, spaces, or dashes.',
				required: true
			}
		}
	}, function (err, result) {

		async.waterfall([


			// Check if development branch exists.
			function (exists, done) {
				api.repos.getBranch({
					user: config.username,
					repo: result.repo,
					branch: 'development'
				}, function (err, result) {
					if (err) {
						console.error('Branch does not exist.');
					}

					done(null, !_.isUndefined(result));
				})
			},

			// Create development branch.
			// function (exists, done) {
			// 	api.repos.
			// }

		], function (err) {
			if (err) {
				console.error('ERROR: Could not initialize repository.');
			}
		});

	});

};
