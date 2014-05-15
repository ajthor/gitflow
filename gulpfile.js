var gulp = require('gulp');
var gutil = require('gulp-util');
var shell = require('gulp-shell');
var git = require('gulp-git');
var docco = require('gulp-docco');

var cache = require('gulp-cached');
var remember = require('gulp-remember');

// Docs Task
// =========
// The `docs` task builds docco files, switches to the gh-pages 
// branch, commits the docs, and switches back to the 
// development branch.
// 
// Usage: `gulp docs`
// 

gulp.task('checkout-master', shell.task(['git checkout master']));

gulp.task('docs-make', ['checkout-master'], function() {
	return gulp.src('./lib/**/*.js')
		.pipe(docco())
		.pipe(cache('docs'))
		.pipe(gulp.dest('./docs/'))
		.on('error', gutil.log);
});

gulp.task('docs-commit', ['docs-make'], shell.task([
	'git checkout gh-pages',
	'git add ./docs',
	'git commit -a -m \"update docs\"',
	'git checkout master',
	'git checkout -b development'
]));

gulp.task('docs', ['docs-commit'], function() {
	git.push('origin', 'gh-pages');
});


