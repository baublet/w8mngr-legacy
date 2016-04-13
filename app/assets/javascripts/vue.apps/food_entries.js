// Wrap this in our initIf call so it only loads if we find the appropo ID
w8mngr.fn.initIf("food-entries-app", function() {

  // A utility function for calculating our calories, fat, carbs, and proteins
  w8mngr.fn.parseTotals = function(array, element) {
    var sum = 0
    w8mngr.fn.forEach(array, function(entry) {
      sum = sum + parseInt(entry[element])
    })
    return sum
  }

  // This is our overarching food entries instance
  w8mngr.foodEntries.app = new Vue({
    template: w8mngr.foodEntries.templates.root,
    el: "#food-entries-app",
    events: {
      'hook:ready': function() {
        this.initializeApp()
      }
    },
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
      autoCompleteSelected: -1,
    },
    components: {
      "food-entry": w8mngr.foodEntries.components.foodEntry,
      "autocomplete-item": w8mngr.foodEntries.components.autoCompleteItem,
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

        // Watch for autocomplete results
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
          protein: protein,
        }

        if (description) {

          // Reset our fields
          this.newDescription = ''
          this.newCalories = ''
          this.newFat = ''
          this.newCarbs = ''
          this.newProtein = ''

          // Add the entry to the model
          // We'll need this to update the item with the index the ruby app returns to us
          // NOTE: Small workaround here. If we don't set a data element on this
          // initial push, Vue doesn't model the reactive getters and setters,
          // which makes it so that when we return an ID from the JSON request,
          // the component never gets the notification to update (because Vue
          // attaches its update chain to its dynamically-generated getters and
          // setters). So we just duplicate the data hash: one for sending, one
          // for populating our Vue properties
          var data_to_send = data
          data.id = null
          var index = this.entries.push(data) - 1

          // Keep our this reference in app so we can manipulate it in the fetch request
          var app = this

          // Format the data for posting to our JSON end point
          data_to_send = {
            food_entry: data_to_send
          }
          data_to_send.food_entry.day = this.currentDayNumber

          // Make the request
          w8mngr.fetch({
            method: "POST",
            url: w8mngr.config.resources.food_entries.add,
            data: data_to_send,
            onSuccess: function(response) {
              if (response.success === false) {
                w8mngr.loading.off()
                alert("Unknown error...")
              } else {
                // Update our ID with the returned response so it can be deleted
                app.entries[index].id = parseInt(response.success)
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
      // This function handles the autocomplete data, which Vue handles with
      // sub-components of this app
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
        console.log(response.results)
        if (response.results.length > 0) {
          var self = this
          w8mngr.fn.forEach(response.results, function(result, i) {
            // This loads the resource we'll use to ping our db for measurement info
            var resource = ("offset" in result && "group" in result) ?
              w8mngr.config.resources.foods.pull(result.ndbno) :
              w8mngr.config.resources.foods.show(result.id)
            self.autoCompleteItems.push({
              name: result.name,
              resource: resource,
              measurements: [],
              measurementsLoaded: 0,
              selectedMeasurement: 0,
            })
          })
        }
      },
      // Handles our arrow key down
      nextAutoCompleteItem: function() {
        // Don't do anything if there aren't any items or they can't go anywhere
        if (this.autoCompleteItems.length < 1) return false
        if (this.autoCompleteSelected == this.autoCompleteItems.length - 1) return false

        console.log("Down: " + (this.autoCompleteSelected + 1))

        this.autoCompleteSelected = this.autoCompleteSelected + 1
      },
      // Handles our arrow key up
      previousAutoCompleteItem: function() {
        // Don't do anything if there aren't any items or they can't go up
        if (this.autoCompleteItems.length < 1) return false
        if (this.autoCompleteSelected < 0) return false

        console.log("Up: " + (this.autoCompleteSelected - 1))

        if (this.autoCompleteSelected >= 0) {
          // Go up one item if they're not at the top already
          this.autoCompleteSelected = this.autoCompleteSelected - 1
        }
      },

      // Selects the next measurement
      nextMeasurement: function(e) {

        // Do nothing if there's no item selected
        if (this.autoCompleteSelected == -1) return false

        // Find our item
        var item = this.autoCompleteItems[this.autoCompleteSelected]

        // Do nothing if we're already at the end of the line
        if (item.selectedMeasurement == (item.measurements.length - 1)) return false

        // Increment our selected measurement counter and call the appropriate function
        item.selectedMeasurement = item.selectedMeasurement + 1
        console.log("Selected next item: " + item.selectedMeasurement)
      },

      // Selects the previous measurement
      previousMeasurement: function(e) {
        // Do nothing if there's no item selected
        if (this.autoCompleteSelected == -1) return false

        // Find our item
        var item = this.autoCompleteItems[this.autoCompleteSelected]

        // Do nothing if we're already on the first measurement
        if (item.selectedMeasurement == 0) return false

        // Decrement our selected measurement and call the appropo function
        item.selectedMeasurement = item.selectedMeasurement - 1
        console.log("Selected previous item: " + item.selectedMeasurement)
      },
    },
  })
})