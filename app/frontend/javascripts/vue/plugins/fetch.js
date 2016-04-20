var w8mngrFetch = {}

w8mngrFetch.fetch = function(options) {
  var method = options.method
    // This makes sure the async_seed adds an additional variable if there are
    // already variables in the URL, or as the only variable if there aren't
    // And we add the async_seed to prevent caching
  var sep = (options.url.indexOf("?") == -1) ? "?" : "&"
  var url = options.url + sep + "async_seed=" + new Date()
    .getTime()
  var onSuccess = (options.onSuccess instanceof Function) ? options.onSuccess : null
  var onError = (options.onError instanceof Function) ? options.onError : null

  var request = new XMLHttpRequest();
  console.log("Launching " + method + " request to " + url)
  request.open(method, url, true);
  if (onSuccess !== null || onError !== null) {
    console.log("Attaching callback  to the " + method + " request...")
    request.onreadystatechange = function() {
      if (this.readyState === 4) {
        console.log(method + " request returned " + this.readyState + "...")
        if (this.status >= 200 && this.status < 400) {
          // Success!
          if (onSuccess !== null) onSuccess(JSON.parse(this.responseText));
        } else {
          // Error :(
          if (onError !== null) onError(this.status, this.error, this.responseText);
        }
      }
    };
  }
  request.setRequestHeader("Accept", "application/json")
  if (method == "POST" || method == "PUT" || method == "PATCH") {
    var data = JSON.stringify(options.data);
    console.log("Sending: " + data)
    request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
    request.send(data);
  } else {
    request.setRequestHeader("Content-Type", "application/json");
    request.send();
  }
  request = null;
}

w8mngrFetch.install = function(externalVue, options) {
  externalVue.prototype.$fetch = this.fetch
  externalVue.prototype.$fetchURI = options.resources
}

module.exports = w8mngrFetch