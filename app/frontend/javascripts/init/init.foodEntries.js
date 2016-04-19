var w8mngr = require("w8mngr")

w8mngr.init.addIf("food-entries-app", function() {
  // mount our Vue instance
  console.log("Loading food-entries-app dependencies...")

  // Load the following asyncronously
  require.ensure(["vue", "../vue/init.js", "../vue/FoodEntries.vue"], function(require) {

    var Vue = require("vue")
    var pluginLoader = require("../vue/init.js")

    console.log("Mounting food-entries-app...")
    var FoodEntriesApp = require("../vue/FoodEntries.vue")
    w8mngr.foodEntries = new Vue(FoodEntriesApp)

    pluginLoader(w8mngr.foodEntries)

  }, "food-entries-chunk")
})