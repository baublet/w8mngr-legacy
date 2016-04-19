// This loads our default Vue plugins and actions

module.exports = function(Vue) {
  var w8mngr = require("w8mngr")

  // Attach our Fetch plugin to Vue
  var fetchPlugin = require("./plugins/fetch.js")
  Vue.use(fetchPlugin, {resources: w8mngr.config.resources})

  // Attach our Cache plugin to Vue
  var cachePlugin = require("./plugins/cache.js")
  Vue.use(cachePlugin)

  console.log("Vue plugins loaded...")
}