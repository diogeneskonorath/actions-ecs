const assert = require('assert');
const hello = require('../hello');

describe('Simple Hello World Test', () => {
    it('should return Hello World', () => {
        assert.equal(hello.getHelloWorld(), "Hello World");
    });
});