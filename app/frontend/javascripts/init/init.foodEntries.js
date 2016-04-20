var w8mngr = require("w8mngr")

w8mngr.init.addIf("food-entries-app", function() {
  // mount our Vue instance
  console.log("Loading food-entries-app dependencies...")

  // Load the following asyncronously
  require.ensure(["vue", "../vue/init.js", "../vue/FoodEntries.vue"], function(require) {

    console.log("Mounting food-entries-app...")

    var Vue = require("vue")
    Vue.use(require("../vue/init.js"))

    w8mngr.foodEntries = new Vue(require("../vue/FoodEntries.vue"))

    console.log("Vue instance for FoodEntries:")
    console.log(w8mngr.foodEntries)

  }, "food-entries-chunk")
})