var w8mngr = require("w8mngr")
var Vue = require("vue")

w8mngr.init.addIf("food-entries-app", function() {
  // mount our Vue instance
  console.log("Loading food-entries-app dependencies...")

  // Load the following asyncronously
  require.ensure(["../vue/init.js", "../vue/FoodEntries.vue"], function(require) {

    require("../vue/init.js")

    console.log("Mounting food-entries-app...")
    var FoodEntriesApp = require("../vue/FoodEntries.vue")
    w8mngr.foodEntries = new Vue(FoodEntriesApp)
    console.log(FoodEntriesApp)
    console.log(w8mngr.foodEntries)

  }, "food-entries-chunk")
})