/* global w8mngr */

var addEvent = require("../fn/addEvent.js")

w8mngr.init.add(function() {

  let turbolinks_loading_handler = document.getElementById("turbolinks-loading-notifier")

  document.w8mngrLoading = function(loading) {
    if(loading) turbolinks_loading_handler.style.display = 'flex'
    else turbolinks_loading_handler.style.display = 'none'
  }

  addEvent(document, "turbolinks:click", function() {
    document.w8mngrLoading(true)
  })
  addEvent(document, "turbolinks:load", function() {
    document.w8mngrLoading(false)
  })
})