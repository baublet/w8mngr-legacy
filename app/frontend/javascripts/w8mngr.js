// Setup the app and its namespaces
var w8mngr = w8mngr || {}

// Cookies
w8mngr.cookies = require("utilities/cookies.js")

// Loading toggle(s)
w8mngr.loading = {}

// The initialization array
w8mngr.init = require("utilities/init.js")

// The Configuration
w8mngr.config = require("config.js")

module.exports = w8mngr