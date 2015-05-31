'use strict';

var fs = require('fs');
var path = require('path');

var _ = require('underscore');
var async = require('async');

var prompt = require('prompt');

var createPullRequest = require('./utils/createPullRequest');

module.exports = function merge (api, config, options) {
	async.series([

    function (done) {
      createPullRequest({
        api: api,
        config: config,
        options: options
      }, done);
    }

  ], function (err) {
    if (err) {
      console.error(err.message);
    }
  });

};
