/**
 * server
 * ローカルサーバをたてるタスク
 */
const gulp = require('gulp');

gulp.task('server', (callback) => {
  const config = require('../config.js');
  const browser = require('browser-sync');
  // const ssi = require('browsersync-ssi');

  browser({
    port: config.server.port,
    server: {
      baseDir: config.path[global.env].root,
      // middleware: [
      //   ssi({ baseDir: config.path.root, ext: '.html' })
      // ]
    },
    startPath: config.server.startPath,
    ghostMode: false,
    browser:'google chrome',
    open: 'local',
    notify: false,
    ui: false
  });

  callback();
});
