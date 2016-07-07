var w8mngr = require("w8mngr")

w8mngr.init.addIf("dashboard-app", function() {
  // mount our Vue instance
  console.log("Loading dashboard-app dependencies...")

  // Load the following asyncronously
  require.ensure(["vue", "../vue/init.js", "../vue/FoodEntries.vue", "chart.js"], function(require) {

    console.log("Mounting dashboard-app...")

    var Vue = require("vue")
    Vue.use(require("../vue/init.js"))

    if(!w8mngr.dashboard)
      w8mngr.dashboard = new Vue(require("../vue/Dashboard.vue"))

  }, "dashboard-chunk")
})