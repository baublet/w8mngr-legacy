// Our App entry point
var w8mngr = require("w8mngr")
console.log("w8mngr configuration loaded...")

// Load Vue
var Vue = require("vue")
console.log("Vue loaded...")

// Attach our Fetch and Cache plugins to Vue
var fetchPlugin = require("vue/plugins/fetch.js")
var cachePlugin = require("vue/plugins/cache.js")
Vue.use(fetchPlugin, {resources: w8mngr.config.resources})
Vue.use(cachePlugin)
console.log("Vue plugins loaded...")

// This includes every file in our init directory
console.log("Loading initialization files...")
require("./init/init.noJS.js")
require("./init/init.navigation.js")
require("./init/init.foodEntries.js")

// Run our initializations
console.log("Initializing w8mngr...")
w8mngr.init.run()