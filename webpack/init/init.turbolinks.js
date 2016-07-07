var w8mngr = require("w8mngr")
var Turbolinks = require("turbolinks")

// Initialize all of our apps by removing the nojs tag from the body
w8mngr.init.add(function() {
  if(Turbolinks.started) return false
  Turbolinks.start()
  console.log("Initializing turbolinks...")
  // Add an event that refires our init if Turbolinks restarts
  document.addEventListener("turbolinks:visit", function(event) {
    w8mngr.init.run()
  })
})