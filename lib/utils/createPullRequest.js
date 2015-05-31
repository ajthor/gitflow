'use strict';

var fs = require('fs');
var path = require('path');

var _ = require('underscore');
var async = require('async');

var prompt = require('prompt');

// Create Pull Request
// -------------------
// Creates a new pull request.
module.exports = function createPullRequest (obj, callback) {
  if (_.isUndefined(obj.base)) throw new Error('ERROR: Must provide a base to \'createPullRequest\'.');
  if (_.isUndefined(obj.head)) throw new Error('ERROR: Must provide a head to \'createPullRequest\'.');

  console.log('Creating pull request...');
  
  prompt.start();

  prompt.get({
    properties: {
      title: {
        message: "Enter a title for the pull request.",
        required: true
      },
      body: {
        message: "Enter a description for the pull request. (Optional)"
      }
    }
  }, function (err, result) {

    obj.api.pullRequests.create({
      user: obj.options.username,
      repo: obj.options.repository,

      title: result.title,
      body: (result.body || ""),

      // Branch to merge into.
      base: obj.base,
      // Branch to merge from.
      head: obj.head

    }, function (err) {
      if (err) {
        console.error(err.message);
      }

      callback();
    });

  });

};
