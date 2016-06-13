// Our initialization functions

module.exports = {
  _toInit: [],
  add: function(fn) {
    if (fn instanceof Function) {
      this._toInit = this._toInit.concat(fn);
    }
  },
  run: function() {
    this._toInit.forEach(function(fn) {
      fn()
    })
  },
  // This is a special utility class I use to only declare certan JS functions if
  // the DOM finds my_app (which should be an ID that corresponds to the app's
  // el on the Vue instance
  addIf: function(my_app, fn) {
    // We attach this to our basic init function so this only loads once
    // the DOM is known and all of our JS is loaded
    this.add(function() {
      if (document.getElementById(my_app) !== null) {
        fn()
      }
    })
  },
}