var w8mngr = new Object();

// Initialize all of our apps by removing the nojs tag from the body
document.querySelector('body').classList.remove('nojs')

// Our basic forEach() function
w8mngr.forEach = function (array, fn) {
  for (var i = 0; i < array.length; i++)
    fn(array[i], i);
}

// Our basic event listener
w8mngr.addEvent = function (el, eventName, handler) {
  if (el.addEventListener) {
    el.addEventListener(eventName, handler);
  } else {
    el.attachEvent("on" + eventName, function(){
      handler.call(el);
    });
  }
}

// My wrapper for a basic JSON function, copied snippets from
// http://youmightnotneedjquery.com/
w8mngr.fetch = function(options) {
  var method = options.method
  var url = options.url
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
  if(method == "POST") {
    var data = options.data;
    request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
    request.send(JSON.stringify(data));
  } else {
    request.setRequestHeader("Content-Type", "application/json");
    request.send();
  }
  request = null;
}
