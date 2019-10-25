/**
 * pug
 * /src/内のpugファイルをコンパイルし/htdocs/に出力するタスク
 *
 * @return {Stream}
 */
const gulp = require('gulp');

gulp.task('pug', () => {
  const config = require('../config.js');
  const pug = require('gulp-pug');
  const plumber = require('gulp-plumber');
  const notify = require('gulp-notify');

  return gulp.src(config.path.src.pug)
    .pipe(plumber({errorHandler:notify.onError('Error: <%= error.message %>')}))
    .pipe(
      pug({
        // locals: {
        //   pug_compile: global.env
        // },
        pretty: true
      })
    )
    .pipe(gulp.dest(config.path[global.env].html));
});
