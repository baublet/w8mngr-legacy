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
      this.initializeData()
    }
  },
  el: '#food-entries-app',
  data: {
    currentDayNumber: '',
    currentDay: '',
    newDescription: '',
    newCalories: '',
    newFat: '',
    newCarbs: '',
    newProtein: '',
    totalCalories: '',
    totalFat: '',
    totalCarbs: '',
    totalProtein: '',
    entries: []
  },
  methods: {
    initializeData: function() {
      w8mngr.loading.on()
      console.log("Fetching data from the API...")
      var app = this
      w8mngr.fetch({
        method: "GET",
        url: w8mngr.config.resources.food_entries.index,
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
    parseDays: function() {
      this.currentDay = w8mngr.fn.numberToDay(this.currentDayNumber)
    },
    addEntry: function (e) {
      if(e) e.stopPropagation()
      w8mngr.loading.on()
      var description = this.newDescription.trim()
      var calories = parseInt(this.newCalories.trim()) || 0
      var fat = parseInt(this.newFat.trim()) || 0
      var carbs = parseInt(this.newCarbs.trim()) || 0
      var protein = parseInt(this.newProtein.trim()) || 0
      var data = { description: description, calories: calories, fat: fat, carbs: carbs, protein: protein }
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
        data = { food_entry: data }
        data.food_entry.day = this.currentDayNumber
        w8mngr.fetch({
          method: "POST",
          url: w8mngr.config.resources.food_entries.add,
          data: data,
          onSuccess: function(response) {
            if(response.success === false) {
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
        document.getElementById("description-input").focus()
      } else {
        document.getElementById("description-input").focus()
      }
    },
    removeEntry: function (index, e) {
      if(e) e.preventDefault()
      w8mngr.loading.on()
      var app = this
      w8mngr.fetch({
        method: "DELETE",
        url: w8mngr.config.resources.food_entries.delete(app.entries[index].id),
        onSuccess: function(response) {
          if(response.success === true) {
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
    saveEntry: function() {
      this.calculateTotals()
    },
    calculateTotals: function() {
      console.log('Calculating totals...')
      this.totalCalories = w8mngr.fn.parseTotals(this.entries, 'calories')
      this.totalFat = w8mngr.fn.parseTotals(this.entries, 'fat')
      this.totalCarbs = w8mngr.fn.parseTotals(this.entries, 'carbs')
      this.totalProtein = w8mngr.fn.parseTotals(this.entries, 'protein')
    }
  }
})
