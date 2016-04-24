var webpack = require('webpack')
<<<<<<< 725c33ba4083b8ff00ae66e8ee53618bbe55bf17
=======
var _ = require('lodash')
>>>>>>> Massive configuration for webpack in prod
var config = module.exports = require('./main.config.js')

config.debug = true
config.displayErrorDetails = true
config.outputPathinfo = true
<<<<<<< 725c33ba4083b8ff00ae66e8ee53618bbe55bf17
config.devtool = 'sourcemap'

config.plugins.push(
  new webpack.optimize.CommonsChunkPlugin('common', 'common-bundle.js')
);
=======
config.devtool = 'sourcemap'
>>>>>>> Massive configuration for webpack in prod
