const assert = require('assert');
const sum = require('../hello');

describe('#hello.js', () => {
	describe('#sum()', () => {
		it('sum() should return 0', () => {assert.strictEqual(sum(), 0);});
	});
	describe('#sum()', () => {
		it('sum() should return 1', () => {assert.strictEqual(sum(1), 1);});
	});
	describe('#sum()', () => {
		it('sum() should return 3', () => {assert.strictEqual(sum(1,2), 3);});
	});
	describe('#sum()', () => {
		it('sum() should return 6', () => {assert.strictEqual(sum(1,2,3), 6);});
	});
});
