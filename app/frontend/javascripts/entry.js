// Our App entry point
var w8mngr = require("w8mngr")
console.log("w8mngr configuration loaded...")

// This includes every file in our init directory
console.log("Loading initialization files...")
require("./init/init.noJS.js")
require("./init/init.navigation.js")
require("./init/init.foodEntries.js")

// Run our initializations
console.log("Initializing w8mngr...")
w8mngr.init.run()