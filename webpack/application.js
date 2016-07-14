// Our small forEach polyfill
if (typeof Array.prototype.forEach !== 'function') {
  Array.prototype.forEach = function(callback, context) {
    for (var i = 0; i < this.length; i++) {
      callback.apply(context, [ this[i], i, this ])
    }
  }
}

// Our App objects
window.w8mngr = require("w8mngr")
console.log("w8mngr configuration loaded...")

// This includes every file in our init directory
console.log("Loading initialization files...")
require("./init/init.noJS.js")
require("./init/init.navigation.js")
require("./init/init.foodEntries.js")
require("./init/init.dashboard.js")
require("./init/init.muscleGroups.js")
require("./init/init.turbolinksLoadingNotifier.js")

// Run our initializations
console.log("Initializing w8mngr...")
var Turbolinks = require("turbolinks")
Turbolinks.start()
console.log("Initializing turbolinks...")

// Add an event that refires our init if Turbolinks restarts
// Also will fire our scripts the first time on initial load
document.addEventListener("turbolinks:load", function(event) {
  w8mngr.init.run()
})