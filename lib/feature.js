'use strict';

var fs = require('fs');
var path = require('path');

var _ = require('underscore');
var async = require('async');

var prompt = require('prompt');

var createBranch = require('./utils/createBranch');
var deleteBranch = require('./utils/deleteBranch');

module.exports = function feature (api, config, options) {
	async.series([

		// Get feature name.
		function (done) {

			if (options.commands.length !== 0) {
				options.featureName = options.commands.pop();
			}

			done(null);

		},

		// Create feature branch.
    function (done) {

      createBranch({
        api: api,
        config: config,
        options: options,
				branch: options.featureName,
				base: 'development'
      }, done);

    }

  ], function (err) {
    if (err) {
      console.error(err.message);
    }
  });

};
