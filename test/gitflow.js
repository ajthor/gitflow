'use strict';

var chai = require('chai'),
	expect = chai.expect,
	assert = chai.assert,
	should = chai.should();

describe('exported object', function () {

	var exported = require('../lib/gitflow.js');

	it('should not be undefined', function () {
		expect(exported).to.not.be.undefined;
	});

	it('should have a prototype', function () {
		expect(exported.prototype).to.not.be.undefined;
	});

	describe('exported object prototype', function () {

		var prototype = exported.prototype;

		it('should have a run function', function () {
			expect(prototype).to.not.be.undefined;
		});

	});

	it('should be instantiable', function () {
		expect(function () {
			var instance = new exported();
		}).not.to.throw();
	});

	describe('exported object instance', function () {

		var instance = new exported();

		it('should have a run function', function () {
			expect(instance.run).to.not.be.undefined;
		});

	});

});
