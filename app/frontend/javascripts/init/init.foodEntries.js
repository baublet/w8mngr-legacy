var w8mngr = require("w8mngr")
var Vue = require("vue")

w8mngr.init.addIf("food-entries-app", function() {
  // mount our Vue instance
  console.log("Loading food-entries-app dependencies...")

  // Load the following asyncronously
  require.ensure(["../vue/FoodEntries.vue"], function(require) {

    console.log("Mounting food-entries-app...")
    var FoodEntriesApp = require("../vue/FoodEntries.vue")
    w8mngr.foodEntries = new Vue(FoodEntriesApp)
    console.log(FoodEntriesApp)
    console.log(w8mngr.foodEntries)

    // Attach our Fetch and Cache plugins to Vue
    var fetchPlugin = require("../vue/plugins/fetch.js")
    var cachePlugin = require("../vue/plugins/cache.js")
    Vue.use(fetchPlugin, {resources: w8mngr.config.resources})
    Vue.use(cachePlugin)
    console.log("Vue plugins loaded...")

  }, "food-entries-chunk")
})