const webpack = require("webpack");
const path = require("path");
// const PrettierPlugin = require('prettier-webpack-plugin');
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
        test: /\.(js|jsx)$/,
        exclude: path.resolve(__dirname, "node_modules"),
        use: {
          loader: "babel-loader"
        }
      }
    ]
  },
  // plugins: [new PrettierPlugin()],
  optimization: {
    minimize: true
  }
};
