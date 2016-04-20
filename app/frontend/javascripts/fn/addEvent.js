// Simple event attacher I like to use

module.exports = function(el, eventName, handler) {
  if (el.addEventListener) {
    el.addEventListener(eventName, handler);
  } else {
    el.attachEvent("on" + eventName, function() {
      handler.call(el);
    });
  }
}