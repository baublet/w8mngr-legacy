var w8mngr = require("w8mngr")
var forEach = require("../fn/forEach.js")
var addEvent = require("../fn/addEvent.js")

w8mngr.init.add(function() {

	console.log("Loading the navigation...")

	// This function loads the cookies and sets the state of our navigation
	// Dashboard is set as the default menu
	if (w8mngr.cookies.getItem("nav_position") === null) w8mngr.cookies.setItem("nav_position", "#app-menu-dashboard")
	var current = w8mngr.cookies.getItem("nav_position")
	console.log("Current item set at: " + current)

	// Checks our checkbox
	var check_boxes = document.querySelectorAll(w8mngr.cookies.getItem("nav_position"))

	// No checkbox found? Then just bail out of this function
	if(typeof check_boxes[0] === 'undefined') return

	check_boxes[0].checked = true

	// Attaches event listeners to the top-level items
	var nav_boxes = document.querySelectorAll(".app-menu-top-option")
	forEach(nav_boxes, function(el) {
		addEvent(el, "click", function() {
			console.log("Navigation item changed to: " + this.getAttribute("id") + ". Updating cookie.")
			w8mngr.cookies.removeItem("nav_position")
			w8mngr.cookies.setItem("nav_position", "#" + this.getAttribute("id"))
			console.log("Current item set at: " + w8mngr.cookies.getItem("nav_position"))
		})
	})
})
