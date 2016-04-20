// Basic class manipulation function to add a class to an element

var hasClass = require("./hasClass.js")

module.export = function(el, className) {
  if (!hasClass(el, className)) {
    if (el.classList) {
      el.classList.add(className)
    } else {
      el.className += ' ' + className
    }
  }
}