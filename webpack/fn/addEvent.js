// Simple event attacher I like to use

module.exports = function(el, eventName, handler) {
  function attachListener(el, eventName, handler) {
    if (el.addEventListener) {
      el.addEventListener(eventName, handler);
    } else {
      el.attachEvent("on" + eventName, function() {
        handler.call(el);
      });
    }
  }
  if(!Array.isArray(eventName)) {
    attachListener(el, eventName, handler)
  } else {
    var length = eventName.length
    for(var i = 0; i < length; i++) {
      attachListener(el, eventName[i], handler)
    }
  }
}