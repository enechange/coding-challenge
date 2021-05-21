global.env = 'release';

const gulp = require('gulp');
const requireDir = require('require-dir');
const config = require('./gulp/config.js');

requireDir('./gulp/tasks', {
  recurse: true
});

const tasks = config.enabled;
console.log(tasks);

gulp.task('default', gulp.parallel(...tasks));
