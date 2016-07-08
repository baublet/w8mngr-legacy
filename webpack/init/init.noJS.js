/* global w8mngr */
var removeClass = require("../fn/removeClass.js")

// Initialize all of our apps by removing the nojs tag from the body
w8mngr.init.add(function() {
  removeClass(document.querySelector('body'), 'nojs')
})