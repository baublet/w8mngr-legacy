/*
 * This script loads every page init in turbolinks and hooks an event to each
 * form element. These events prevent the default behavior, submits the form
 * via XHR, and then tells Turbolinks to visit the appropriate page on redirect.
 * (Note: all of our forms redirect.)
 *
 * This only attaches to forms with POST as the method
 */

/* global w8mngr */

var addEvent = require("../fn/addEvent.js")

w8mngr.init.add(function() {

  takeOverForms()

  addEvent(document, "turbolinks:load", function() {
    takeOverForms()
  })

  function takeOverForms() {
    var elements = document.querySelectorAll("form[method=post]")
    elements.forEach(function(el) {
      if (el.w8mngrWatched) return false
      console.log("Taking over form with action " + el.action)
      el.w8mngrWatched = true
      addEvent(el, "submit", function(e) {
        // Stop the form from submitting
        e.preventDefault()
        document.w8mngrLoading(true)
        // Send it via XHR
        xhrForm(el, function(xhr, response) {
          response = xhr.currentTarget
          // Turbolinks 5 doesn't have a replace method at the moment, so I'm
          // doing it myself manually here. The creator of Turbolinks wants us
          // to instead alter our serverside code to return javascript that tells
          // TL what to do... asinine considering TL's original purpose (progressive
          // enhancement).
          console.log(response)
          let url = response.responseURL
          if (url !== window.location.href) {
            window.Turbolinks.visit(url)
          } else {
            Turbolinks.clearCache()
            document.documentElement.innerHTML = response.responseText
            history.pushState({turbolinks: true, url: url}, '', url)
            Turbolinks.dispatch("turbolinks:load")
            document.w8mngrLoading(false)
          }
        })
      })
    })
  }

  // Borrowed from StackOverflow,
  // http://stackoverflow.com/questions/6990729/simple-ajax-form-using-javascript-no-jquery/26556347#26556347
  function xhrForm(form, callback) {
    var xhr = new XMLHttpRequest()
    var params = [].filter.call(form.elements, function (el) {return !(el.type in ['checkbox', 'radio']) || el.checked})
    .filter(function(el) { return !!el.name }) //Nameless elements die.
    .filter(function(el) { return !el.disabled }) //Disabled elements die.
    .map(function(el) {
        return encodeURIComponent(el.name) + '=' + encodeURIComponent(el.value);
    }).join('&') //Then join all the strings by &
    xhr.open("POST", form.action)
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
    xhr.onload = callback.bind(xhr)
    xhr.send(params)
  }
})