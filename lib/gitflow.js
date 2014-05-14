// Require underscore.
var _ = require("underscore");

// Object Object
// =============
// description
var obj = module.exports = function() {
	if(!(this instanceof obj)) {
		return new obj(arguments);
	}

	// Once constructor has run, and all setup has been completed for
	// this instance, run the initialize function.
	this.initialize.call(this, arguments);
};

Object.defineProperties(obj.prototype, {});

_.extend(obj.prototype, {
	
	initialize: function() {}
	
});