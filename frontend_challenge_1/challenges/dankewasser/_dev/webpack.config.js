const webpack = require("webpack");
const path = require("path");
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const config = require("./gulp/config.js");

module.exports = {
  mode: "development",

  // メインのJS
  entry: config.path.src.js_entry,
  // 出力ファイル
  output: {
    path: path.resolve(__dirname, config.path.release.js),
    filename: "app.js"
  },
  // devtool: 'source-map',
  devtool: "inline-source-map",
  module: {
    rules: [
      {
        enforce: "pre",
        test: /\.(js|jsx)$/,
        exclude: path.resolve(__dirname, "node_modules"),
        use: {
          loader: "eslint-loader",
          options: {
            fix: true,
            failOnError: true
          }
        }
      },
      {
        test: /\.vue$/,
        loader: 'vue-loader',
      },
      {
        test: /\.pug$/,
        loader: 'pug-plain-loader',
      },
      {
        test: /\.(js|jsx)$/,
        exclude: path.resolve(__dirname, "node_modules"),
        use: {
          loader: 'babel-loader',
          options: {
            presets: [['@babel/preset-env', { useBuiltIns: 'usage' }]],
          },
        }
      }
    ]
  },
  plugins: [
    new VueLoaderPlugin()
  ],
  optimization: {
    minimize: true
  }
};
