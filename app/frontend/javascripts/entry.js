var Vue = require("vue")

// Our App entry point
var w8mngr = require("w8mngr")

// Attach our Fetch and Cache plugins to Vue
var fetchPlugin = require("vue/plugins/fetch.js")
var cachePlugin = require("vue/plugins/cache.js")
Vue.use(fetchPlugin, {resources: w8mngr.config.resources})
Vue.use(cachePlugin)

// This includes every file in our init directory
require.context(
  "./init",
  true,
  /.*/
)("./" + expr + "")

// Run our initializations
w8mngr.init.run()