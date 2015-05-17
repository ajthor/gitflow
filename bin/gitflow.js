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

// _.extend(inkblot.prototype, require('./'));

// GitFlow Prototype
// -----------------
_.extend(gitflow.prototype, {

	run: function (command) {

	}

});