// Toggles the loading animation on or off if there is an app-form in the page
w8mngr.loading = {
  on: function() {
    // First, show all of the loading notification icons (which should be invisible)
    w8mngr.fn.forEach(document.querySelectorAll('.app-form .loading'), function(el) {
      el.style.display = "block"
    })
    // Then, add the loading class to all of our app-forms
    w8mngr.fn.forEach(document.querySelectorAll('.app-form'), function(el) {
      w8mngr.fn.addClass(el,"loading")
    })
  },
  off: function() {
    var els = document.querySelectorAll('.app-form')
    // Remove the loading class from each app-form
    w8mngr.fn.forEach(els, function(el) {
      w8mngr.fn.removeClass(el,"loading")
    })
    // Then, after 250ms (the delay for our animation), hide all the loading
    // notification icons
    w8mngr.do(function() {
      w8mngr.fn.forEach(document.querySelectorAll('.app-form .loading'), function(el) {
        el.style.display = "none"
      })
    }, 250)
  }
}
