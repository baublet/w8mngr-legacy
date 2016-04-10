w8mngr.fn.parseTotals = function(array, element) {
  var sum = 0
  w8mngr.fn.forEach(array, function(entry) {
    sum = sum + parseInt(entry[element])
  })
  return sum
}

w8mngr.foodEntries.app = new Vue({
  events: {
    'hook:ready': function() {
      this.initializeApp()
    }
  },
  el: '#food-entries-app',
  data: {
    currentDayNumber: '',
    currentDay: '',
    prevDay: '',
    nextDay: '',
    newDescription: '',
    newCalories: '',
    newFat: '',
    newCarbs: '',
    newProtein: '',
    totalCalories: '',
    totalFat: '',
    totalCarbs: '',
    totalProtein: '',
    entries: [],
    autoCompleteItems: [],
    autoCompleteSelected: -1
  },
  methods: {
    // Some basic initialization things that I put here because the Vue app
    // needs to be loaded for many of these methods to work
    initializeApp: function() {
      // Finds the current date based on the URL string
      var find_day = w8mngr.config.regex.foodlog_day.exec(window.location.href)
      var day = ""
      try {
        day = find_day[1]
      } catch (e) {}
      // Then, load the day if specified, otherwise it loads the current day
      this.loadDay(day)
        // Testing my autocomplete function...
      this.$watch("newDescription", function(searchTerm) {
        this.autoComplete(searchTerm)
      })
    },
    // Send an entry to be added to the database
    addEntry: function() {
      w8mngr.loading.on()
      var description = this.newDescription.trim()
      var calories = parseInt(this.newCalories.trim()) || 0
      var fat = parseInt(this.newFat.trim()) || 0
      var carbs = parseInt(this.newCarbs.trim()) || 0
      var protein = parseInt(this.newProtein.trim()) || 0
      var data = {
        description: description,
        calories: calories,
        fat: fat,
        carbs: carbs,
        protein: protein
      }
      if (description) {
        // We'll need this to update the item with the index the ruby app returns to us
        var index = this.entries.push(data) - 1
          // Reset our fields
        this.newDescription = ''
        this.newCalories = ''
        this.newFat = ''
        this.newCarbs = ''
        this.newProtein = ''
          // Keep our this reference in app so we can manipulate it in the fetch request
        var app = this
          // Format the data for posting
        data = {
          food_entry: data
        }
        data.food_entry.day = this.currentDayNumber
        w8mngr.fetch({
          method: "POST",
          url: w8mngr.config.resources.food_entries.add,
          data: data,
          onSuccess: function(response) {
            if (response.success === false) {
              w8mngr.loading.off()
              alert("Unknown error...")
            } else {
              app.entries[index].id = response.success
              w8mngr.loading.off()
            }
          },
          onError: function(response) {
            alert("ERROR: " + response)
          }
        })
        this.calculateTotals()
        document.getElementById("description-input")
          .focus()
      } else {
        document.getElementById("description-input")
          .focus()
      }
    },
    // Sends an entry to be removed from the database
    removeEntry: function(index) {
      w8mngr.loading.on()
      var app = this
      w8mngr.fetch({
        method: "DELETE",
        url: w8mngr.config.resources.food_entries.delete(app.entries[index].id),
        onSuccess: function(response) {
          if (response.success === true) {
            app.entries.splice(index, 1)
            app.calculateTotals()
            w8mngr.loading.off()
          } else {
            alert("Unknown error...")
          }
        },
        onError: function(response) {
          alert("ERROR: " + response)
        }
      })
    },
    // Sends an entry to be saved to the database
    saveEntry: function(index) {
      w8mngr.loading.on()
      this.calculateTotals()
      var data = {
        food_entry: {
          description: this.entries[index].description,
          calories: this.entries[index].calories,
          fat: this.entries[index].fat,
          carbs: this.entries[index].carbs,
          protein: this.entries[index].protein
        }
      }
      var app = this
      w8mngr.fetch({
        method: "POST",
        url: w8mngr.config.resources.food_entries.update(app.entries[index].id),
        data: data,
        onSuccess: function(response) {
          if (response.success == true) {
            w8mngr.loading.off()
          } else {
            alert("Unknown error...")
          }
        },
        onError: function(response) {
          alert("ERROR:" + response)
        }
      })
    },
    // Update the macro totals using a useful custom function
    calculateTotals: function() {
      this.totalCalories = w8mngr.fn.parseTotals(this.entries, 'calories')
      this.totalFat = w8mngr.fn.parseTotals(this.entries, 'fat')
      this.totalCarbs = w8mngr.fn.parseTotals(this.entries, 'carbs')
      this.totalProtein = w8mngr.fn.parseTotals(this.entries, 'protein')
    },
    // Loads the day after the currenct day
    loadNextDay: function() {
      this.loadDay(this.nextDay)
    },
    // Loads the day before the current day
    loadPrevDay: function() {
      this.loadDay(this.prevDay)
    },
    // Switches to a new day. If no argument is specified, it uses today
    loadDay: function(day = "") {
      w8mngr.loading.on()
      console.log("Fetching data from the API...")
      w8mngr.state.push({}, w8mngr.config.resources.food_entries.from_day(day))
      var app = this
      w8mngr.fetch({
        method: "GET",
        url: w8mngr.config.resources.food_entries.from_day(day),
        onSuccess: function(response) {
          app.entries = response.entries
          app.currentDayNumber = response.current_day
          app.calculateTotals()
          app.parseDays()
          w8mngr.loading.off()
        },
        onError: function(response) {
          alert("ERROR:" + response)
        }
      })
    },
    // This function takes this.currentDayNum and renders a nice day display
    // for the rest of the dates relative to the currently-showed date
    parseDays: function() {
      this.currentDay = w8mngr.fn.numberToDay(this.currentDayNumber)
      this.prevDay = w8mngr.fn.yesterdayNumber(this.currentDayNumber)
      this.nextDay = w8mngr.fn.tomorrowNumber(this.currentDayNumber)
      console.log("Parsed previous day: " + this.prevDay + " -- And next day: " + this.nextDay)
    },
    // This function handles the autocomplete data
    autoComplete: function(query) {
      var app = this
      w8mngr.fetch({
        method: "get",
        url: w8mngr.config.resources.search_foods(query),
        onSuccess: function(response) {
          if (response.success === false) {
            alert("Unknown error...")
          } else {
            app.formatAutoCompleteResults(response)
          }
        },
        onError: function(response) {
          alert("ERROR: " + response)
        }
      })
    },
    // This function formats the autoComplete data, which will consist of USDA
    // foods, our users' foods, and recipes, so we have to massage it!
    formatAutoCompleteResults(response) {
      console.log("Parsing autocomplete items")
      this.autoCompleteItems = []
      this.autoCompleteSelected = -1
      if (response.results.length > 0) {
        var app = this
        w8mngr.fn.forEach(response.results, function(result, i) {
          app.autoCompleteItems.push({
            domId: "autocomplete-item-" + i,
            name: result.name
          })
        })
      }
    },
    // Handles our arrow key down
    keyDown: function() {
      // Don't do anything if there aren't any items or they can't go anywhere
      if (this.autoCompleteItems.length < 1) return false;
      if (this.autoCompleteSelected == this.autoCompleteItems.length - 1) return false
      console.log("Down pressed")
      var current_el = null
        // Only deselect the previous item if there's an item selected
      if (this.autoCompleteSelected >= 0) {
        current_el = document.getElementById(this.autoCompleteItems[this.autoCompleteSelected].domId)
        w8mngr.fn.removeClass(current_el, "selected")
      }
      this.autoCompleteSelected++;
      current_el = document.getElementById(this.autoCompleteItems[this.autoCompleteSelected].domId)
      w8mngr.fn.addClass(current_el, "selected")
    },
    // Handles our arrow key up
    keyUp: function() {
      // Don't do anything if there aren't any items or they can't go up
      if (this.autoCompleteItems.length < 1) return false;
      console.log("Up pressed")
      var current_el = document.getElementById(this.autoCompleteItems[this.autoCompleteSelected].domId)
      w8mngr.fn.removeClass(current_el, "selected")
      this.autoCompleteSelected--;
      // If they're at the top and go one more up, don't reselect
      if (this.autoCompleteSelected == 0) {
        current_el = document.getElementById(this.autoCompleteItems[this.autoCompleteSelected].domId)
        w8mngr.fn.addClass(current_el, "selected")
      }
    }
  }
})