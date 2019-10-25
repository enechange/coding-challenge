/**
 * minimg
 * 画像を圧縮するタスク
 *
 * @return {Stream}
 */
const gulp = require('gulp');

gulp.task('imgmin', () => {
  const config = require('../config.js');
  const plumber = require('gulp-plumber');
  const notify = require('gulp-notify');
  const imagemin = require('gulp-imagemin');
  const pngquant = require('imagemin-pngquant');
  const mozjpeg = require('imagemin-mozjpeg');

  return gulp.src(config.path.src.img)
    // エラー時にプロセスが落ちないようにする
    .pipe(plumber({errorHandler:notify.onError('Error: <%= error.message %>')}))
    .pipe(imagemin([
      pngquant({ // PNGの最適化
        quality: '100-100',
        speed: 1,
        floyd: 0
      }),
      mozjpeg({ //jpgの最適化
        quality: 85,
        progressive: true
      }),
      imagemin.optipng(), // pngquantで付加されてしまうガンマ情報を除去する
      imagemin.gifsicle() //Gif画像の最適化
    ]))
    .pipe(gulp.dest(config.path[global.env].img));
});
