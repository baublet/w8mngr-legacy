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

  // Whenever turbolinks brings up a new page, this will ensure that new forms
  // are taken over by this script
  addEvent(document, "turbolinks:load", function() {
    takeOverForms()
  })

  function takeOverForms() {
    // First, we need to hijack all of the buttons in the form to prevent
    // mobile browsers from auto-submitting things
    /*let buttons = document.querySelectorAll("form[method=post] button[type=submit]")
    console.log(buttons)
    buttons.forEach(function(el) {
      addEvent(el, ["click"], function(e) {
        el.form.w8mngrSubmit()
      })
    })*/

    // Now, let's hijack the form submit action
    let forms = document.querySelectorAll("form[method=post]")
    forms.forEach(function(el) {
      // Already watched? Skip it
      if (el.w8mngrWatched) return false
      el.w8mngrWatched = true
      console.log("Taking over form with action " + el.action)

      // Stop the form submission process
      addEvent(el, "submit", function(e) {
        e.preventDefault()
        document.w8mngrLoading(true)
        // Send it via XHR
        xhrForm(el, function(xhr, response) {
          response = xhr.currentTarget
          // Turbolinks 5 doesn't have a replace method at the moment, so I'm
          // doing it myself manually here. The creator of Turbolinks wants us
          // to instead alter our serverside code to return javascript that tells
          // TL what to do... asinine considering TL's original purpose (progressive
          // enhancement and quicker app development).
          let url = response.responseURL
          if (url !== window.location.href) {
            window.Turbolinks.visit(url)
          } else {
            window.requestAnimationFrame(function() {
              // Let's grab the body from the respose
              let parser = new DOMParser()
              let doc = parser.parseFromString(response.responseText, "text/html")
              console.log(doc)
              Turbolinks.clearCache()
              document.getElementById("main").innerHTML = doc.getElementById("main").innerHTML
              history.pushState({turbolinks: true, url: url}, '', url)
              Turbolinks.dispatch("turbolinks:load")
              window.scroll(0,0)
              document.w8mngrLoading(false)
            })
          }
        })
        return false
      })
    })
  }

  // Borrowed from StackOverflow,
  // http://stackoverflow.com/questions/6990729/simple-ajax-form-using-javascript-no-jquery/26556347#26556347
  function xhrForm(form, callback) {
    let xhr = new XMLHttpRequest()
    let params = [].filter.call(form.elements, function(el) { return true })
    .filter(function(el) {
      if(['checkbox', 'radio'].indexOf(el.type) > -1) {
        return document.getElementById(el.id).checked
      } else {
        return true
      }
    })                                            // Unchecked checkboxes die
    .filter(function(el) { return !!el.name })    // Nameless elements die
    .filter(function(el) { return !el.disabled }) // Disabled elements die
    .map(function(el) {
        return encodeURIComponent(el.name) + '=' + encodeURIComponent(el.value);
    }).join('&') //Then join all the strings by &
    xhr.open(form.method, form.action)
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
    xhr.onload = callback.bind(xhr)
    console.log("Sending " + params + " to " + form.action)
    xhr.send(params)
  }
})