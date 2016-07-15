/* global w8mngr */

w8mngr.init.addIf("food-entries-app", function() {
  // mount our Vue instance
  console.log("Loading food-entries-app dependencies...")

  // Load the following asyncronously
  require.ensure(["vue", "../vue/init.js", "../vue/FoodEntries.vue"], function(require) {

    if(w8mngr.foodEntries) {
      // Nuke the old vm and make a new one
      console.log("Nuking the old FoodEntries vm...")
      w8mngr.foodEntries.$destroy()
    }

    console.log("Mounting food-entries-app...")

    var Vue = require("vue")
    Vue.use(require("../vue/init.js"))

    w8mngr.foodEntries = new Vue(require("../vue/FoodEntries.vue"))

  }, "food-entries-chunk")
})