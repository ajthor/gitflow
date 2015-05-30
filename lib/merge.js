'use strict';

var fs = require('fs');
var path = require('path');

var _ = require('underscore');
var async = require('async');

var prompt = require('prompt');

var createPullRequest = function (api, config, options, callback) {
  prompt.start();

  prompt.get({
    properties: {
      title: {
        message: "Enter a title for the pull request.",
        required: true
      },
      body: {
        message: "(Optional) Enter a description for the pull request."
      }
    }
  }, function (err, result) {

    api.pullRequests.create({
      user: options.username,
      repo: options.repository,

      title: result.title,
      body: (result.body || ""),

      // Branch to merge into.
      base: "development",
      // Branch to merge from.
      // head: Current branch.

    }, function (err) {
      if (err) {
        console.error(err.message);
      }

      callback();
    });

  });

};

exports.merge = function (api, config, options) {
	async.series([

    createPullRequest(api, config, options, done)

  ], function (err) {
    if (err) {
      console.error(err.message);
    }
  });

};
