var addEvent = require("../fn/addEvent.js")

w8mngr.init.add(function() {

	// Don't redo this script if turbolinks is on, indicating that it's already
	// been run
	if (window.Turbolinks) return false

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
	for (let i = 0; i < nav_boxes.length; ++i) {
		let el = nav_boxes[i]
		addEvent(el, "click", function() {
			w8mngr.cookies.removeItem("nav_position")
			w8mngr.cookies.setItem("nav_position", "#" + this.getAttribute("id"))
		})
	}
})
