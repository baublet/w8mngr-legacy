var w8mngrFetch = {}

// This is our basic fetch function. Don't call it with this function. Instead
// use w8mngrFetch.fetch()!

w8mngrFetch.fetch = function(index) {
  if (index == null) console.error("Cannot pass a null index to Fetch!")
  var options = this.$queue[parseInt(index, 10)]
  var method = options.method

  console.log("Fetch options: ")

  // This makes sure the async_seed adds an additional variable if there are
  // already variables in the URL, or as the only variable if there aren't
  // And we add the async_seed to prevent caching
  var sep = (options.url.indexOf("?") == -1) ? "?" : "&"
  var url = options.url + sep + "async_seed=" + new Date().getTime()

  // Set our callback functions. If one is passed, the passed one takes precedence.
  // Otherwise, we use the default callback if one is set

  var onSuccess = (options.onSuccess instanceof Function) ? options.onSuccess : this.$onSuccess
  var onError = (options.onError instanceof Function) ? options.onError : this.$onError
  var onResponse = (options.onResponse instanceof Function) ? options.onResponse : this.$onResponse

  var request = new XMLHttpRequest()

  request.open(method, url, true)

  // Only worry about callbacks if there's a callback to worry abut!
  var w8mngrFetchObject = this
  if (onSuccess !== null || onError !== null || onResponse !== null) {
    console.log("Attaching callbacks to our response object...")

    request.onreadystatechange = function() {

      if (this.readyState === 4) {

        if(onResponse !== null) onResponse(this.response)

        if (this.status >= 200 && this.status < 400) {

          // Success! Remove this from the queue and add it to the completed pile
          if (onSuccess !== null) onSuccess(JSON.parse(this.response));
          w8mngrFetchObject.$completed.push(w8mngrFetchObject.$queue[index])
          w8mngrFetchObject.$queue.splice(index, 1)

        } else {

          // Error :(
          if (onError !== null) onError(this.status, this.error, this.response);
          w8mngrFetchObject.$failed.push(w8mngrFetchObject.$queue[index])

        }

        // Do we move on to the next item (indicating that this is a syncronous request)?
        if (w8mngrFetchObject.$sync) w8mngrFetchObject.processQueue(true)

      }

    }

  }

  // Send the request!
  request.setRequestHeader("Accept", "application/json")

  if (method == "POST" || method == "PUT" || method == "PATCH") {
    var data = JSON.stringify(options.data);
    console.log("Sending: " + data)
    request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
    request.send(data);
  } else {
    console.log("Sending GET request...")
    request.setRequestHeader("Content-Type", "application/json");
    request.send();
  }
  console.log("Launching " + method + " request to " + url)

  request = null;
}

// Our queue is an array of option hashes that executes each of the fetch requests,
// only removing them if they succeeded. If they succeed, the element is removed
// from the queue and added to the completed pile. If they fail, they stay in the queue
// and are added to the failed pile
w8mngrFetch.$queue = []
w8mngrFetch.$completed = []
w8mngrFetch.$failed = []

/*
  Processes our fetch queue
*/
w8mngrFetch.processQueue = function(sync) {
  var length = this.$queue.length
  if(length < 1) return null
  sync = sync == null ? false : Boolean(sync)

  // If it's an async call, do them all at once
  if(!sync) {
    this.$sync = false
    for (var i = 0; i < length; i++) {
      this.fetch(i)
    }
  } else {
    // Otherwise, just do the first one, and the Fetch function will know to call
    // this function again with sync = true after the previous request is complete
    this.$sync = true
    this.fetch(0)
  }
  return null
}

/*
  This function is a wrapper for our main fetch function
  You can pass a few options to it apart from the basic fetch functions

  delay:    The delay in milliseconds before adding this to the queue
            Default: 0

  proc:     If set to true, fetch will add this request to the queue and immediately
            trigger a queue execution
            Default: true

  priority: If set to true, this request will go to the top. If false, this
            request will be appended to the queue and wait its turn)
            Default: false
 */
w8mngrFetch.$ = function(options) {
  // Figure out how we're going to add this to the queue
  var delay = options.delay == null ? 0 : parseInt(options.delay, 10)
  var proc = options.proc == null ? true : Boolean(options.proc)
  var priority = options.priority == null ? false : Boolean(options.priority)

  var w8mngrFetchObject = this
  window.setTimeout(function() {
    // Put it at the beginning if it's high priority
    if(priority) w8mngrFetchObject.$queue.unshift(options)
    // Otherwise, put it at the end of the queue
    else w8mngrFetchObject.$queue.push(options)
    // Process the queue if we're supposed to
    if(proc) w8mngrFetchObject.processQueue()
  }, delay)
}

// Allows you to set a default OnError, OnSuccess, and OnResponse value to use
// if nothing is passed it
w8mngrFetch.setDefault = function(type, fn) {
  if (typeof fn !== "function") return false
  switch(type) {
    case "onError":
      this.$onError = fn
      break
    case "onSuccess":
      this.$onSuccess = fn
      break
    case "onResponse":
      this.$onResponse = fn
      break
    default: return false
  }
  return true
}
w8mngrFetch.$onError = null
w8mngrFetch.$onSuccess = null
w8mngrFetch.$onResponse = null

// This function will be called by Vue, installing it
w8mngrFetch.install = function(externalVue, options) {

  // Our full class installation and some basic wrappers
  externalVue.prototype.$fetch_module = w8mngrFetch
  externalVue.prototype.$fetch = function(options) { this.$fetch_module.$(options) }

  // w8mngr's custom resources I pass in at installation
  externalVue.prototype.$fetchURI = options.resources
}

module.exports = w8mngrFetch