/**
 * config.js
 * gulpの設定ファイル
 */
module.exports = {
  name: 'enechange-biz',

  // local serverの設定
  server: {
    port:      4008,
    startPath: './'
  },

  browsers: [
    'ie >= 11',
    'ios >= 11',
    'android >= 6'
  ],

  // 有効にするタスクを配列で書く
  enabled: [
    'pug',
    'scss',
    'concat-js-libs',
    'server',
    'watch'
  ],

  // gulp内で利用する各種ファイルへのパス
  path: {
    cacheLocation: '.css-cache',

    watch: {
      pug: [
        './pug/**/*.pug'
      ],
      ejs: [
        './ejs/**/*.ejs'
      ],
      scss: [
        './scss/**/*.scss'
      ],
      stylus: [
        './stylus/**/*.styl'
      ],
      js: [
        './js/**/*.js'
      ],
      js_libs: ['./js/lib/**/*.js'],
      img: ['./images/**/*.{jpg,jpeg,png,gif,svg,ico}']
    },

    copy: {
      js: [
        // './src/**/copy.js'
      ],
      img: [
        // './images/**/*.{svg}',
        // '!./images/**/_*.{svg}'
      ]
    },

    src: {
      root:     './',
      pug:      ['./pug/**/*.pug', '!./pug/**/_*.pug'],
      ejs:      ['./ejs/**/*.ejs', '!./ejs/**/_*.ejs'],
      scss:     ['./scss/**/*.scss', '!./scss/**/_*.scss'],
      stylus:   ['./stylus/**/*.styl', '!./stylus/**/_*.styl'],
      js:       [
        './js/**/*.js',
        '!./js/lib/**/*.js',
        '!./js/**/_*.js'
      ],
      js_entry: './js/app.js',
      js_libs:  [
        './js/lib/jquery-3.3.1.min.js',
        './js/lib/*'
      ],
      img:      [
        './images/**/*.{jpg,jpeg,png,gif,svg,ico}',
        '!./images/**/_*.{jpg,jpeg,png,gif,svg,ico}'
      ]
    },

    lint: {
      scss: {
        src:  ['./scss/**/*.scss', '!./scss/reset/*.scss', '!./scss/plugins/*.scss'],
        dest: './scss/',
        tmp:  './tmp/scss/'
      }
    },

    release: {
      root:    '../',
      html:    '../',
      js:      '../assets/js/',
      js_libs: '../assets/js/',
      css:     '../assets/css/',
      img:     '../assets/images/'
    }
  }
};
