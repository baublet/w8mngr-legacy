/* global history */

// A very simple wrapper for the PushState API
module.exports = {
  current: function() {
    if(history.state) return history.state
  },
  push: function(stateObject, url) {
    try {
      history.pushState(stateObject, "", url)
      return true
    } catch(e) { return false }
  },
  replace: function(stateObject, url) {
    try {
      history.replaceState(stateObject, "", url)
      return true
    } catch(e) { return false }
  }
}
