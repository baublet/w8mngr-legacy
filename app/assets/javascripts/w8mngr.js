// Setup the app and its namespaces
var w8mngr = w8mngr || {}
  // Commonly used functions
w8mngr.fn = {}
  // Cookies
w8mngr.cookies = {}
  // Loading toggle(s)
w8mngr.loading = {}
  // Our fetcher
w8mngr.fetch = {}

// The initialization array
w8mngr.init = {
  _toInit: [],
  add: function(fn) {
    if (fn instanceof Function) {
      this._toInit = this._toInit.concat(fn);
    }
  },
  run: function() {
    w8mngr.fn.forEach(this._toInit, function(fn) {
      fn()
    })
  }
}

// Food entries app namespace
w8mngr.foodEntries = {}

// The Configuration
w8mngr.config = {
  regex: {
    foodlog_day: /foodlog\/(\d{8})/
  },
  resources: {
    base: "/",
    search_foods: function(q) {
      return "/search/foods/?q=" + q
    },
    foods: {
      pull: function(ndbno) {
        return "/foods/pull/" + ndbno
      },
      show: function(id) {
        return "/foods/" + id
      }
    },
    food_entries: {
      index: "/food_entries/",
      add: "/food_entries/",
      delete: function(id) {
        return "/food_entries/" + id
      },
      from_day: function(day = "") {
        return "/foodlog/" + day
      },
      update: function(id) {
        return "/food_entry/" + id
      }
    }
  }
}

// We want to remove the "nojs" tag, which hides all of our javascript
// only divs. Also, removing this element hides our HTML fallbacks
w8mngr.init.add(function() {
  w8mngr.fn.removeClass(document.querySelector('body'), 'nojs')
})