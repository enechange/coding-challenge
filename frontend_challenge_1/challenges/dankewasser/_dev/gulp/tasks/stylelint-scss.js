/**
 * stylelintScss
 * scssがスタイル規約に従っているかをチェックしてプロパティを並び替えて元ファイルに上書きするタスク
 *
 * @return {Stream}
 */
const gulp = require('gulp');

gulp.task('stylelintScss', () => {
  const config = require('../config.js');

  const plumber = require('gulp-plumber');
  const notify = require('gulp-notify');

  const postcss = require('gulp-postcss');
  const postcssScss = require('postcss-scss');
  const stylelint = require('stylelint');
  const reporter = require('postcss-reporter');

  return gulp.src(config.path.lint.scss.src)
    .pipe(plumber({
      errorHandler:notify.onError({
        title: '😱  Stylelint Error!',
        message: '\nスタイル規約違反の記述があります\n\n'
      })
    }))
    .pipe(postcss([
      stylelint({ fix: false }),
      reporter({ clearMessages: true, throwError: false })
    ], {syntax: postcssScss}));
});
