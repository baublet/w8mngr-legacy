// Basic class manipulation functions

w8mngr.fn.hasClass = function(el, className) {
  if (el.classList) {
    return el.classList.contains(className);
  } else {
    return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
  }
}

w8mngr.fn.addClass = function(el, className) {
  if(!w8mngr.fn.hasClass(el, className)) {
    if (el.classList) {
      el.classList.add(className)
    } else {
      el.className += ' ' + className
    }
  }
}

w8mngr.fn.removeClass = function(el, className) {
  if(w8mngr.fn.hasClass(el, className)) {
    if (el.classList) {
      el.classList.remove(className)
    } else {
      el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
    }
  }
}
