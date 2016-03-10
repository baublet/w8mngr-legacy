w8mngr.fetch = function(options) {
  var method = options.method
  var url = options.url + "?async_seed=" + new Date() . getTime()
  var onSuccess = (options.onSuccess instanceof Function) ? options.onSuccess : null
  var onError = (options.onError instanceof Function) ? options.onError : null

  var request = new XMLHttpRequest();
  console.log("Launching " + method  + " request to " + url)
  request.open(method, url, true);
  if(onSuccess !== null || onError !== null) {
    console.log("Attaching callback  to the " + method + " request...")
    request.onreadystatechange = function() {
      if (this.readyState === 4) {
        console.log(method + " request returned " + this.readyState + "...")
        if (this.status >= 200 && this.status < 400) {
          // Success!
          if(onSuccess !== null) onSuccess(JSON.parse(this.responseText));
        } else {
          // Error :(
          if(onError !== null) onError(this.status, this.error, this.responseText);
        }
      }
    };
  }
  request.setRequestHeader("Accept", "application/json")
  if(method == "POST" || method == "PUT" || method == "PATCH") {
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
