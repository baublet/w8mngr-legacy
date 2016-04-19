// Basic class manipulation function for telling if an element has a class

module.exports = function(el, className) {
  if (el.classList) {
    return el.classList.contains(className);
  } else {
    return new RegExp('(^| )' + className + '( |$)', 'gi')
      .test(el.className);
  }
}