// This loads our default Vue plugins and actions

var w8mngr = require("w8mngr")

module.exports = {

  install: function(externalVue) {
    // Attach our Fetch plugin to Vue
    var fetchPlugin = require("./plugins/fetch.js")
    externalVue.use(fetchPlugin, {resources: w8mngr.config.resources})

    // Attach our Cache plugin to Vue
    var cachePlugin = require("./plugins/cache.js")
    externalVue.use(cachePlugin)

    console.log("Vue plugins loaded...")
  },

}