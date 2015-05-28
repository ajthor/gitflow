'use strict';

var fs = require('fs');
var path = require('path');

var _ = require('underscore');
var async = require('async');

var GitHubAPI = require('github');
var prompt = require('prompt');

// GitHub API object.
var github = new GitHubAPI({
	version: '3.0.0',

	debug: true,
	protocol: 'https'
});

var gitflow = module.exports = function (options) {
	this.options = _.defaults((options || {}), {
		// GitFlow Defaults
	}, this.options);
};

_.extend(gitflow.prototype, require('../lib/init.js'));
_.extend(gitflow.prototype, require('../lib/feature.js'));
_.extend(gitflow.prototype, require('../lib/issue.js'));
_.extend(gitflow.prototype, require('../lib/release.js'));

// GitFlow Prototype
// -----------------
_.extend(gitflow.prototype, {

	authenticate: function () {
		github.authorization.create({
		    scopes: ["public_repo", "repo", "repo:status", "gist"],
		    note: "GitFlow CLI access.",
		    note_url: "http://url-to-this-auth-app",
		    headers: {
		        "X-GitHub-OTP": "two-factor-code"
		    }
		}, function(err, res) {
		    if (res.token) {
		        //save and use res.token as in the Oauth process above from now on
		    }
		});
	},

	run: function (commands) {
		if (!_.has(gitflow.prototype, commands[0])) {
			process.exit(9);
		}

		this.authenticate(obj);
	}

});
