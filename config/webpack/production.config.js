var webpack = require('webpack');
var ChunkManifestPlugin = require('chunk-manifest-webpack-plugin');
var path = require('path');

var config = module.exports = require('./main.config.js');

config.output.path = path.join(config.context, 'public', 'assets')
config.output.filename = '[name]-bundle-[chunkhash].js'
config.output.chunkFilename = '[id]-bundle-[chunkhash].js'

config.plugins.push(
  new webpack.optimize.CommonsChunkPlugin('common', 'common-[chunkhash].js'),
  new ChunkManifestPlugin({
    filename: 'webpack-common-manifest.json',
    manfiestVariable: 'webpackBundleManifest',
  }),
  new webpack.optimize.UglifyJsPlugin(),
  new webpack.optimize.OccurenceOrderPlugin()
);