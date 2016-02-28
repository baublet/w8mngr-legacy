w8mngr.ready(function() {
	console.log("Loading the navigation...");
	w8mngr.initializeNavigation();
});

w8mngr.initializeNavigation = function() {
	// This function loads the cookies and sets the state of our navigation
	if (w8mngr.Cookies.getItem("navPosition") === null) w8mngr.Cookies.setItem("navPosition", "#app-menu-dashboard");
	console.log("Current item set at: " + w8mngr.Cookies.getItem("navPosition"));
	// Checks our checkbox
	document.querySelectorAll(w8mngr.Cookies.getItem("navPosition"))[0].checked = true;
	// Attaches event listeners to the top-level items
	var nav_boxes = document.querySelectorAll(".app-menu-top-option");
	w8mngr.forEach(nav_boxes, function(el) {
		w8mngr.addEvent(el, "click", function() {
			console.log("Navigation item changed to: " + this.getAttribute("id") + ". Updating cookie.");
			w8mngr.Cookies.setItem("navPosition", "#" + this.getAttribute("id"));
			console.log("Current item set at: " + w8mngr.Cookies.getItem("navPosition"));
		});
	});
};