var w8mngr = require("w8mngr")
var Turbolinks = require("turbolinks")

w8mngr.init.addIf("food-entries-app", function() {
  // mount our Vue instance
  console.log("Loading food-entries-app dependencies...")

  // Load the following asyncronously
  require.ensure(["vue", "../vue/init.js", "../vue/FoodEntries.vue"], function(require) {

    console.log("Mounting food-entries-app...")

    var Vue = require("vue")
    Vue.use(require("../vue/init.js"))

    if(w8mngr.foodEntries) w8mngr.foodEntries.$destroy()

    w8mngr.foodEntries = new Vue(require("../vue/FoodEntries.vue"))

  }, "food-entries-chunk")
})