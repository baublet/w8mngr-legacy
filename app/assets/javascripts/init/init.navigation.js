w8mngr.init.add(function() {
	console.log("Loading the navigation...")
	// This function loads the cookies and sets the state of our navigation
	if (w8mngr.cookies.getItem("navPosition") === null) w8mngr.cookies.setItem("navPosition", "#app-menu-dashboard")
	console.log("Current item set at: " + w8mngr.cookies.getItem("navPosition"))
	// Checks our checkbox
	var check_boxes = document.querySelectorAll(w8mngr.cookies.getItem("navPosition"))
	if(typeof check_boxes[0] === 'undefined') return
	check_boxes[0].checked = true
	// Attaches event listeners to the top-level items
	var nav_boxes = document.querySelectorAll(".app-menu-top-option")
	w8mngr.fn.forEach(nav_boxes, function(el) {
		w8mngr.fn.addEvent(el, "click", function() {
			console.log("Navigation item changed to: " + this.getAttribute("id") + ". Updating cookie.")
			w8mngr.cookies.setItem("navPosition", "#" + this.getAttribute("id"))
			console.log("Current item set at: " + w8mngr.cookies.getItem("navPosition"))
		})
	})
})
