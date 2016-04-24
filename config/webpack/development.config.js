var webpack = require('webpack')
var _ = require('lodash')
var config = module.exports = require('./main.config.js')

config.debug = true
config.displayErrorDetails = true
config.outputPathinfo = true
config.devtool = 'sourcemap'