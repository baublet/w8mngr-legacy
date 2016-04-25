// Basic class manipulation function to remove a class from an element

var hasClass = require("./hasClass.js")

module.exports = function(el, className) {
  if (hasClass(el, className)) {
    if (el.classList) {
      el.classList.remove(className)
    } else {
      el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ')
        .join('|') + '(\\b|$)', 'gi'), ' ');
    }
  }
}