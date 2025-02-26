/**
 * watch
 * 対象ファイルを監視し変更があった場合に実行するタスク
 */

const gulp = require('gulp');

gulp.task('watch', (callback) => {
  const config = require('../config.js');
  const watch = require('gulp-watch');

  const tasks = config.enabled;

  if (tasks.includes('pug')) gulp.watch(config.path.watch.pug, gulp.task('pug'));
  if (tasks.includes('ejs')) gulp.watch(config.path.watch.ejs, gulp.task('ejs'));
  if (tasks.includes('scss')) gulp.watch(config.path.watch.scss, gulp.task('scss'));
  if (tasks.includes('stylus')) gulp.watch(config.path.watch.stylus, gulp.task('stylus'));
  if (tasks.includes('concat-js-libs')) gulp.watch(config.path.watch.js_libs, gulp.task('concat-js-libs'));
  if (tasks.includes('imgmin')) gulp.watch(config.path.watch.img, gulp.task('imgmin'));

  callback();
});
