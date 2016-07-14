/* global w8mngr */

var addEvent = require("../fn/addEvent.js")

w8mngr.init.add(function() {

  let turbolinks_loading_handler = document.getElementById("turbolinks-loading-notifier")
  addEvent(document, "turbolinks:click", function() {
    turbolinks_loading_handler.style.display = 'flex'
  })
  addEvent(document, "turbolinks:load", function() {
    turbolinks_loading_handler.style.display = 'none'
  })
})