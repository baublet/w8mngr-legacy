/* global history */

// A very simple wrapper for the PushState API.

module.exports = {
  current: function() {
    if(!history) return false
    if(history.state) return history.state
    return false
  },
  push: function(stateObject, url) {
    try {
      if(history.state == url) return true
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
