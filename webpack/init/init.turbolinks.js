var w8mngr = require("w8mngr")
var Turbolinks = require("turbolinks")

// Initialize all of our apps by removing the nojs tag from the body
w8mngr.init.add(function() {
  // We don't want to run this function if we already have!
  if(window.Turbolinks) return false
  Turbolinks.start()
  console.log("Initializing turbolinks...")
  // Add an event that refires our init if Turbolinks restarts
  document.addEventListener("turbolinks:load", function(event) {
    w8mngr.init.run()
  })
})