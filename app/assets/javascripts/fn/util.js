// Basic utility classes

// Our basic forEach() function
w8mngr.fn.forEach = function(array, fn) {
  for (var i = 0; i < array.length; i++)
    fn(array[i], i);
}

// Our basic event listener
w8mngr.fn.addEvent = function(el, eventName, handler) {
  if (el.addEventListener) {
    el.addEventListener(eventName, handler);
  } else {
    el.attachEvent("on" + eventName, function() {
      handler.call(el);
    });
  }
}

// This is a special utility class I use to only declare certan JS functions if
// the DOM finds my_app (which should be an ID that corresponds to the app's
// el on the Vue instance
w8mngr.fn.initIf = function(my_app, fn) {
  // We attach this to our basic init function so this only loads once
  // the DOM is known and all of our JS is loaded
  w8mngr.init.add(function() {
    if (document.getElementById(my_app) !== null) {
      fn()
    }
  })
}