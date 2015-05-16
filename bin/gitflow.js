var GitHubAPI = require('github');
var prompt = require('prompt');

var github = new GitHubAPI({
	version: '3.0.0',

	debug: true,
	protocol: 'https'
});


