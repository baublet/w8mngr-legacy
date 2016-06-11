var numberToDay = require("../../fn/numberToDay.js")
var tomorrowNumber = require("../../fn/tomorrowNumber.js")
var yesterdayNumber = require("../../fn/yesterdayNumber.js")
var forEach = require("../../fn/forEach.js")
var smoothScroll  = require("../../fn/smoothScroll.js")
var _do = require("../../fn/do.js")

var state = require("../../utilities/pushState.js")

import AutocompleteItem from "../AutocompleteItem.vue"
import FoodEntry from "../FoodEntry.vue"

// This is our overarching food entries component
export default {
  el: "#food-entries-app",
  events: {
    "hook:ready": function() {
      this.initializeApp()
    },
    "loading": function() {
      this.loading = 1
    },
    "not-loading": function() {
      this.loading = 0
    },
  },
  computed: {
    overTotalCalories: function() {
      if (!this.user.preferences.target_calories) return false
      if(this.totalCalories > parseInt(this.user.preferences.target_calories, 10)) return true
      return false
    },
    totalCalories: function() {
      var sum = 0
      forEach(this.entries, function(entry) {
        sum = sum + parseInt(entry["calories"], 10)
      })
      return sum
    },
    totalFat: function() {
      var sum = 0
      forEach(this.entries, function(entry) {
        sum = sum + parseInt(entry["fat"], 10)
      })
      return sum
    },
    totalCarbs: function() {
      var sum = 0
      forEach(this.entries, function(entry) {
        sum = sum + parseInt(entry["carbs"], 10)
      })
      return sum
    },
    totalProtein: function() {
      var sum = 0
      forEach(this.entries, function(entry) {
        sum = sum + parseInt(entry["protein"], 10)
      })
      return sum
    },
  },
  data: {
    loading: 1,
    currentDayNumber: "",
    currentDay: "",
    prevDay: "",
    nextDay: "",
    newDescription: "",
    // Our error messages
    errors: [],
    hostReachable: true,
    connectionTimer: null,
    connectionRetries: 0,
    connectionRetryCountdown: 0,
    // We store the measurement name here to add when the user triggers our
    // addEntry method. This is so that the user looping through measurements
    // doesn"t mess with the autocomplete
    newDescriptionTemp: null,
    newCalories: "",
    newFat: "",
    newCarbs: "",
    newProtein: "",
    entries: [],
    autocompleteItems: [],
    autocompleteSelected: -1,
    autocompleteLoading: 0,
    // Pagination for autocomplete items
    perPage: 10,
    page: 1,
    nextPage: null,
    prevPage: null,
    // We only need a few default values to ensure we don't have lots of errors
    user: {
      id: null,
      preferences: {
        faturday_enabled: false,
      },
    },
  },
  components: {
    AutocompleteItem,
    FoodEntry,
  },
  methods: {
    // Some basic initialization things that I put here because the Vue app
    // needs to be loaded for many of these methods to work
    initializeApp: function() {
      console.log("Initializing the FoodEntries app...")
      var app = this

      // Setup our errors and watchers for the connection
      this.$fetch_module.setDefault("onError", function(status, error, response) {
        app.doErrors(status, error, response)
      })
      this.connectionTimer = setInterval( function() {
        if (app.hostReachable) return false
        // Only do anything if our retries ping is 0
        if (app.connectionRetryCountdown > 1) {
          app.connectionRetryCountdown--
          return false
        }
        console.log("Uh oh! Not connected. Trying to reconnect...")
        // So we're not reachable and it's time to retry? Launch the connection
        // retry attempt
        app.$fetch_module.hostReachable(function(reachable) {
          if(reachable) {
            // We're connected! Cool, let's reset the retry timers and start
            // going through our queue
            app.hostReachable = true
            app.connectionRetries = 0
            app.connectionRetryCountdown = 0
            // We process the queue after 500 milliseconds to prevent having to
            // do a rapid redraw
            _do(function() { app.$fetch_module.processQueue() }, 500)
          } else {
            // Still not connected, boost our retries by 1
            app.hostReachable = false
            app.connectionRetries++
            app.connectionRetryCountdown = app.connectionRetries * 3
          }
        })
      }, 1000);

      // Finds the current date based on the URL string
      var find_day = /foodlog\/(\d{8})/.exec(window.location.href)
      var day = ""
      if (find_day) day = find_day[1]
      else day = null
      // Then, load the day if specified, otherwise it loads the current day
      app.loadDay(day)

      // Watch for autocomplete results
      this.$watch("newDescription", function(searchTerm) {
        this.page = 1
        this.autocomplete(searchTerm)
        if (window.innerWidth < 640)
            smoothScroll.scrollVerticalToElementById("description-input", 20)
      })

      // Load the user information for preferences
      this.$fetch({
        method: "GET",
        url: this.$fetchURI.current_user,
        onSuccess: function(response) {
          // Add the user return data to our model
          app.user = response
        },
      })
    },
    faturday: function() {
      // Sets this day to Faturday
      this.$emit("loading")
      var app = this
      this.$fetch({
        method: "GET",
        url: this.$fetchURI.faturday(app.currentDayNumber),
        onSuccess: function(response) {
          // Add the user return data to our model
          app.entries.push(response.entry)
          app.$emit("not-loading")
        },
      })
    },
    // Send an entry to be added to the database
    addEntry: function() {

      var description = this.newDescriptionTemp || this.newDescription.trim()
      var calories = parseInt(this.newCalories) || 0
      var fat = parseInt(this.newFat) || 0
      var carbs = parseInt(this.newCarbs) || 0
      var protein = parseInt(this.newProtein) || 0

      var data = {
        description: description,
        calories: calories,
        fat: fat,
        carbs: carbs,
        protein: protein,
      }

      if (description) {

        this.$emit("loading")

        // Reset our fields
        this.newDescription = ""
        this.newDescriptionTemp = null
        this.newCalories = ""
        this.newFat = ""
        this.newCarbs = ""
        this.newProtein = ""
        this.autocompleteItems = []
        this.page = 1
        this.nextPage = null
        this.prevPage = null

        // Add the entry to the model
        // We'll need this to update the item with the index the ruby app returns to us
        // NOTE: Small workaround here. If we don"t set a data element on this
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
        this.$fetch({
          method: "POST",
          url: this.$fetchURI.food_entries.add,
          data: data_to_send,
          onSuccess: function(response) {
            // Update our ID with the returned response so it can be deleted
            app.entries[index].id = parseInt(response.id)
            app.$emit("not-loading")
          },
        })
        document.getElementById("description-input")
          .focus()
        // Scroll to our description input if we're on mobile
        // Removing this because pretty much every mobile device already does this
        //if (window.innerWidth < 640)
        //    smoothScroll.scrollVerticalToElementById(this.$el.id, 100)
      } else {
        // TODO: show a fancy error here
        document.getElementById("description-input")
          .focus()
      }
    },
    // Fills in the form with pre-entered data
    fillInForm: function(data) {
      console.log(data)
      this.newDescriptionTemp = data.description
      this.newCalories = data.calories
      this.newFat = data.fat
      this.newCarbs = data.carbs
      this.newProtein = data.protein
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
      this.$emit("loading")
      console.log("Fetching data from the API...")
      if(day !== this.currentDay && day) state.replace({}, this.$fetchURI.food_entries.from_day(day))
      var app = this
      this.$fetch({
        method: "GET",
        url: this.$fetchURI.food_entries.from_day(day),
        onSuccess: function(response) {
          app.$emit("not-loading")
          app.entries = response.entries
          app.currentDayNumber = response.current_day
          app.parseDays()
        },
      })
    },
    // This function takes this.currentDayNum and renders a nice day display
    // for the rest of the dates relative to the currently-showed date
    parseDays: function() {
      this.currentDay = numberToDay(this.currentDayNumber)
      this.prevDay = yesterdayNumber(this.currentDayNumber)
      this.nextDay = tomorrowNumber(this.currentDayNumber)
      console.log("Parsed previous day: " + this.prevDay + " -- And next day: " + this.nextDay)
    },
    // This function handles the autocomplete data, which Vue handles with
    // sub-components of this app
    autocomplete: function(query) {
      // Delete the current results
      this.autocompleteItems = []

      if (this.autocompleteLoading) return false
      // Only do anything if the entered input is > 2 letters
      if (query.length <= 2) return false

      this.autocompleteLoading = 1
      var app = this
      this.$fetch({
        method: "get",
        url: this.$fetchURI.search_foods(query, app.page),
        onSuccess: function(response) {
          app.autocompleteLoading = 0
          if (response.success === false) {
            alert("Unknown error...")
          } else {
            app.formatAutocompleteResults(response)
          }
        },
      })
    },
    // This function formats the autocomplete data, which will consist of USDA
    // foods, our users" foods, and recipes, so we have to massage it!
    formatAutocompleteResults: function(response) {
      console.log("Parsing autocomplete items")
      this.autocompleteSelected = -1
      console.log(response)
      if (response.results.length > 0) {
        this.nextPage = response.next_page
        this.prevPage = this.page > 1 ? this.page - 1 : null
        this.$log()
        var app = this
        forEach(response.results, function(result, i) {
          // This loads the resource we'll use to ping our db for measurement info
          var resource = ("offset" in result && "group" in result) ?
                         app.$fetchURI.foods.pull(result.ndbno) :
                         app.$fetchURI.foods.show(result.id)
          app.autocompleteItems.push({
            id: result.id,
            name: result.name,
            resource: resource,
            measurements: [],
            measurementsLoaded: 0,
            selectedMeasurement: 0,
          })
        })
      }
    },
    // Handles prev/next for autocomplete
    autocompletePage: function(page) {
      this.page = page
      this.autocomplete(this.newDescription)
    },
    // Handles selecting an autocomplete item. If index is undefined, this function
    // selects the currently-selected one
    selectAutocompleteItem: function(index) {
      index = index ? index : this.autocompleteSelected
      this.$children.forEach(function(item) {
        item.$emit('autocomplete-item-selected', index)
      })
    },
    // Handles our arrow key down
    nextAutocompleteItem: function() {
      // Don't do anything if there aren't any items or they can't go anywhere
      if (this.autocompleteItems.length < 1) return false
      if (this.autocompleteSelected == this.autocompleteItems.length - 1) return false
      console.log("Down: " + (this.autocompleteSelected + 1))
      this.autocompleteSelected++
      this.selectAutocompleteItem()
    },
    // Handles our arrow key up
    prevAutocompleteItem: function() {
      // Don't do anything if there aren't any items or they can't go up
      if (this.autocompleteItems.length < 1) return false
      if (this.autocompleteSelected < 0) return false
      console.log("Up: " + (this.autocompleteSelected - 1))
      // Go up one item if they're not at the top already
      this.autocompleteSelected--
      this.selectAutocompleteItem()
    },

    // Selects the next measurement
    nextMeasurement: function() {
      this.$bus.$emit('next-measurement')
    },

    // Selects the previous measurement
    previousMeasurement: function() {
      this.$bus.$emit('prev-measurement')
    },

    // Handles our error messages
    doErrors: function(status, error, response) {
      if(error == undefined) return false
      console.log("There was an error! Status: " + status + ". Error: " + error + ".")
      if(error >= 400 && error <= 500) {
        this.hostReachable = false
      } else {
        alert("Unknown error! Status: " + status + ". Error: " + error + ". Response: " + response + ".")
      }
    },
    // Retries the connection if the user is disconnected
    retryConnection: function() {
      if(this.hostReachable) return false
      this.connectionRetryCountdown = 0
    },
  },
}