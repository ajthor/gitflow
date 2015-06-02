'use strict';

var _ = require('underscore');
var async = require('async');

var prompt = require('prompt');

// Delete Branch
// -------------
// Delete branch if it exists.
module.exports = function deleteBranch (obj, callback) {
  if (_.isUndefined(obj.branch)) throw new Error('ERROR: Must provide a branch to \'deleteBranch\'.');

  async.waterfall([

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

		// Create branch if it doesn't exist.
		function (exists, done) {

      if (!exists) {
        console.log('Branch does not exist.');
        return done(null);
      }

      console.log('Deleting \'' + obj.branch + '\' branch...');

			obj.api.gitdata.deleteReference({
				user: obj.config.username,
				repo: obj.options.repo,
				ref: 'refs/heads/' + obj.branch
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
