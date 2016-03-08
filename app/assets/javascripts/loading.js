// Toggles the loading animation on or off if there is an app-form in the page
w8mngr.loading = {
  on: function() {
    var els = document.querySelectorAll('.app-form')
    w8mngr.fn.forEach(els, function(el) {
      w8mngr.fn.addClass(el,"loading")
    })
  },
  off: function() {
    var els = document.querySelectorAll('.app-form')
    w8mngr.fn.forEach(els, function(el) {
      w8mngr.fn.removeClass(el,"loading")
    })
  }
}
