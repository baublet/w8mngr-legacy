var w8mngr = require("w8mngr")
var Vue = require("vue")

w8mngr.init.initIf("food-entries-app", function() {
  // mount our Vue instance
  console.log("Loading food-entries-app dependencies...")
  require.ensure(["../vue/FoodEntries.vue"], function(require) {
    console.log("Mounting food-entries-app...")
    var FoodEntriesApp = require("../vue/FoodEntries.vue")
    new Vue({
      el: "#food-entries-app",
      components: {
        "food-entries": FoodEntriesApp
      }
    })
  }, "food-entries-chunk")
})