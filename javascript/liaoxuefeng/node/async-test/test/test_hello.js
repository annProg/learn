const assert = require('assert');
const hello = require('../hello');

describe('#async hello', () => {
	describe('#asyncCalculate()', () => {
		it('#async function', async () => {let r = await hello();assert.strictEqual(r, 15);});
	});
});
