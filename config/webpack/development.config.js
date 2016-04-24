var webpack = require('webpack')
var config = module.exports = require('./main.config.js')

config.debug = true
config.displayErrorDetails = true
config.outputPathinfo = true
config.devtool = 'sourcemap'

config.plugins.push(
  new webpack.optimize.CommonsChunkPlugin('common', 'common-bundle.js')
);