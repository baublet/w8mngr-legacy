// A very simple wrapper for the PushState API
w8mngr.state = {
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
