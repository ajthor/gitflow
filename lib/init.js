'use strict';

var chai = require('chai'),
	expect = chai.expect,
	assert = chai.assert,
	should = chai.should();

describe('exported object', function () {

	var exported = require('../bin/gitflow.js');

	it('should not be undefined', function () {
		expect(exported).to.not.be.undefined;
	});

});