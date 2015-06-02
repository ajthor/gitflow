'use strict';

var _ = require('underscore');
var async = require('async');

var prompt = require('prompt');

// Create Branch
// -------------------------
// If branch already exists, do nothing. Otherwise, create one.
module.exports = function createBranch (obj, callback) {
  if (_.isUndefined(obj.base)) throw new Error('ERROR: Must provide a base to \'createBranch\'.');

  async.waterfall([

    // If branch name is undefined, prompt for branch name.
    function (done) {

      if (_.isUndefined(obj.branch)) {
        prompt.start();

        prompt.get({
          properties: {
            name: {
              message: 'Branch name',
              required: true
            }
          }
        }, function (err, result) {
          if (err) {
            console.error(err.message);
          }

          obj.branch = result.name;

          return done(null);

        });
      }
      else {
        return done(null);
      }

    },

    // Check if branch exists.
    function (done) {

      obj.api.repos.getBranch({
				user: obj.config.username,
				repo: obj.options.repo,
        branch: obj.branch
      }, function (err, result) {
        if (!_.isUndefined(result)) {
          return done(null, true);
        }

        return done(err, false);
      });

    },

		// Get sha for BASE.
		function (exists, done) {

      if (exists) {
        return done(null);
      }

			console.log('Fetching sha for \'' + obj.base + '\'.');

			obj.api.gitdata.getReference({
				user: obj.config.username,
				repo: obj.options.repo,
				ref: 'heads/' + obj.base
			}, function (err, result) {
				if (err) {
					return done(err);
				}

        var sha = (result) ? result.object.sha : null;
				console.log(sha);

				return done(null, sha);
			});

		},

		// Create branch if it doesn't exist.
		function (exists, sha, done) {

      if (exists) {
        console.log('Branch already exists.');
        return done(null);
      }

      console.log('Creating \'' + obj.branch + '\' branch...');

			obj.api.gitdata.createReference({
				user: obj.config.username,
				repo: obj.options.repo,
				ref: 'refs/heads/' + obj.branch,
				sha: (sha || obj.sha)
			}, function (err, result) {
				if (err) {
					return done(err);
				}

				return done(null);
			});

		}

	], function (err) {
		if (err) {
			console.error(err);
		}

    callback();
	});
};
