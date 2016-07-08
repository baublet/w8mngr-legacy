w8mngr.init.addIf("food-entries-app", function() {
  // mount our Vue instance
  console.log("Loading food-entries-app dependencies...")

  // Load the following asyncronously
  require.ensure(["vue", "../vue/init.js", "../vue/FoodEntries.vue"], function(require) {

    if(window.w8mngr.foodEntries) return false

    console.log("Mounting food-entries-app...")

    var Vue = require("vue")
    Vue.use(require("../vue/init.js"))

    window.w8mngr.foodEntries = new Vue(require("../vue/FoodEntries.vue"))

  }, "food-entries-chunk")
})