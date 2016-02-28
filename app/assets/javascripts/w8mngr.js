var w8mngr = new Object();

// Our basic forEach() function
w8mngr.forEach = function (array, fn) {
  for (var i = 0; i < array.length; i++)
    fn(array[i], i);
}

// Our basic event listener
w8mngr.addEvent = function (el, eventName, handler) {
  if (el.addEventListener) {
    el.addEventListener(eventName, handler);
  } else {
    el.attachEvent('on' + eventName, function(){
      handler.call(el);
    });
  }
}