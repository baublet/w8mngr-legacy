/* global w8mngr */

// Initialize all of our apps by removing the nojs tag from the body
w8mngr.init.add(function() {
  w8mngr.fn.removeClass(document.querySelector('body'), 'nojs')
})