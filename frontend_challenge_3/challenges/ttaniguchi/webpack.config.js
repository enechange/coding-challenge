const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { GitRevisionPlugin } = require('git-revision-webpack-plugin');
const ESLintPlugin = require('eslint-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');

const devServer = {
  static: {
    directory: path.resolve(__dirname, 'dist'),
    watch: true,
  },
  host: 'localhost',
  hot: true,
  open: ['/'],
  port: 8080,
};

module.exports = (env, { mode }) => {
  const isProduction = mode === 'production';
  const gitRevision = new GitRevisionPlugin();
  const deployTime = new Date().toString();

  return {
    cache: {
      type: 'filesystem',
      buildDependencies: {
        config: [__filename],
      },
    },
    context: __dirname,
    devServer: isProduction ? {} : devServer,
    devtool: isProduction ? false : 'source-map',
    entry: {
      bundle: './src/js/index.tsx',
    },
    output: {
      filename: './assets/js/[name].[contenthash].js',
      path: path.resolve(__dirname, 'dist'),
      clean: true,
    },
    module: {
      rules: [
        {
          test: /\.tsx?$/,
          use: 'ts-loader',
        },
        {
          test: /\.scss$/,
          use: ['style-loader', 'css-loader', 'sass-loader'],
        },
      ],
    },
    optimization: {
      // 本番ビルドのみ圧縮
      minimize: isProduction,
      minimizer: [
        new TerserPlugin({
          extractComments: false,
          terserOptions: {
            compress: {
              drop_console: true,
              drop_debugger: true,
            },
            output: {
              beautify: false,
              comments: false,
            },
          },
        }),
      ],
    },
    performance: {
      maxAssetSize: 1024 * 1024 * 3,
      maxEntrypointSize: 1024 * 1024 * 3,
    },
    plugins: [
      new CopyWebpackPlugin({
        patterns: [{ from: './src/htdocs', to: './' }],
      }),
      new ESLintPlugin({
        extensions: ['ts', 'tsx'],
        exclude: [path.resolve(__dirname, 'node_modules')],
      }),
      new HtmlWebpackPlugin({
        minify: false,
        filename: 'index.html',
        template: './src/index.html',
        deployTime,
        title: 'test',
        version: gitRevision.commithash(),
      }),
    ],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, 'src'),
      },
      extensions: ['.ts', '.tsx', '.js'],
    },
  };
};
